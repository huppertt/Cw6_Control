function [time,data,auxdata,concdata]=rt_gssm(time,data,auxdata,concdata,stim)

persistent GSS_model;
persistent iH;
persistent handles;
persistent E;

persistent P_k;
persistent X_k;

if(isempty(data))
    
    try
        figure(handles.figure1)
    catch
        %Initialize the empty model
        [GSS_model,handles,iH]=init_gssm_imagerecon;
    end
    
    %STate covariance model
    P_k=1*speye(GSS_model.model.statedim,GSS_model.model.statedim);
    X_k=zeros(GSS_model.model.statedim,1);

    Arg.type = 'state';                                 % inference type (state estimation)
    Arg.tag = 'State estimation for GLM system.';       % arbitrary ID tag
    Arg.model = GSS_model.model;                                % GSSM data structure of external system
    GSS_model.InfDS = geninfds(Arg);  
    
    E=GetExtinctions([690 830]);
    E=E(1:2,1:2);
    return;
end

dOD=0*concdata;

h=guihandles(findobj('tag','cw6figure'));
SubjInfo=get(h.RegistrationInfo,'UserData');
Measlist=SubjInfo.Probe.MeasList;
lst1=find(Measlist(:,4)==1);
lst2=find(Measlist(:,4)==2);

for id=1:size(concdata,2)
    tmp=1E-6*E*[concdata([lst1],id) concdata([lst2],id)]';
    dOD(lst1,id)=tmp(1,:);
    dOD(lst2,id)=tmp(2,:);
end

Arg.type = 'state';                                 % inference type (state estimation)
Arg.tag = 'State estimation for GLM system.';       % arbitrary ID tag
Arg.model = GSS_model.model;                                % GSSM data structure of external system
GSS_model.InfDS = geninfds(Arg);

Y=cat(1,dOD*1E3,sparse(size(dOD,1),size(dOD,2)));
[X_k,P_k,pNoise, oNoise, InternalVariablesDS]=ekf_k(X_k,P_k,GSS_model.pNoise,GSS_model.oNoise,Y,[],time,GSS_model.InfDS);

%Now, image recon
HbO=iH*X_k;
disp(1);
set(handles.brainL,'FaceVertexCData',HbO);
set(handles.brainR,'FaceVertexCData',HbO);

return
