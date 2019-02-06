function [time,data,auxdata,concdata]=rt_gssm_imagerecon(time,data,auxdata,concdata,stim)

persistent GSS_model;
persistent handles;
persistent iH;
persistent P_k;
persistent X_k;

if(isempty(data))

    [GSS_model,handles,iH]=init_gssm_imagerecon;
 
    P_k=1*eye(GSS_model.model.statedim,GSS_model.model.statedim);
    X_k=zeros(GSS_model.model.statedim,1);
    Yh_k=zeros(GSS_model.model.obsdim,1);
    
    err=ones(GSS_model.model.obsdim,1);
    GSS_model.model.T=@(k)calcTk(-999,k);
     
    Arg.type = 'state';                                 % inference type (state estimation)
    Arg.tag = 'State estimation for GLM system.';       % arbitrary ID tag
    Arg.model = GSS_model.model;                                % GSSM data structure of external system
    GSS_model.InfDS = geninfds(Arg);  

    return;
end

% Data has to be converted to dOD
dOD = -log(data);
Y=cat(2,dOD,sparse(size(dOD,1),size(dOD,2)));


%% Now, update the state-space model

Arg.type = 'state';                                 % inference type (state estimation)
Arg.tag = 'State estimation for GLM system.';       % arbitrary ID tag
Arg.model = GSS_model.model;                                % GSSM data structure of external system
GSS_model.InfDS = geninfds(Arg);

[X_k,P_k,pNoise, oNoise, InternalVariablesDS]=ekf_k(X_k,P_k,GSS_model.pNoise,GSS_model.oNoise,dOD,[],time,GSS_model.InfDS);


%Now, recover the image
HbO=iH*X_k;
set(handles.brainL,'FaceVertexCData',HbO);
set(handles.brainR,'FaceVertexCData',HbO);


return