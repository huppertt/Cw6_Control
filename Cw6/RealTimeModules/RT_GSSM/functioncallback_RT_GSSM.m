function [time,data,auxdata,concdata]=rt_gssm(time,data,auxdata,concdata,stim)

persistent GSS_model;

persistent P_k;
persistent X_k;
persistent Yh_k;

persistent ml_lst1;
persistent ml_lst2;

persistent err;

if(isempty(data))
    if(isempty(findobj('tag','GSSM_Figure')))
        handles=guihandles(findobj('tag','cw6figure'));
        SubjInfo=get(handles.RegistrationInfo,'UserData');
        SD=SubjInfo.Probe;
        init_gssmGUI(SD);
        reset_gssmGUI(SD);   
        ml_lst1=find(SD.MeasList(:,4)==1);
        ml_lst2=find(SD.MeasList(:,4)==2);
    else
        reset_gssmGUI;
    end
    
    GSS_model=init_gssm;
    P_k=1*eye(GSS_model.model.statedim,GSS_model.model.statedim);
    X_k=zeros(GSS_model.model.statedim,1);
    Yh_k=zeros(GSS_model.model.obsdim,1);
    
    err=ones(GSS_model.model.obsdim,1);
    GSS_model.model.T=@(k)calcTk(stim,k);
    
    Arg.type = 'state';                                 % inference type (state estimation)
    Arg.tag = 'State estimation for GLM system.';       % arbitrary ID tag
    Arg.model = GSS_model.model;                                % GSSM data structure of external system
    GSS_model.InfDS = geninfds(Arg);  
    
    figurehandle=findobj('tag','cw6figure');
    Cw6_data = get(figurehandle,'UserData');
    Cw6_data.data.X=[];
    set(figurehandle,'UserData',Cw6_data);
        
    return;
end

if(isempty(ml_lst1))
    handles=guihandles(findobj('tag','cw6figure'));
    SubjInfo=get(handles.RegistrationInfo,'UserData');
    SD=SubjInfo.Probe;
    ml_lst1=find(SD.MeasList(:,4)==1);
    ml_lst2=find(SD.MeasList(:,4)==2);
end

AddReg=[mean(concdata(ml_lst1).*err(ml_lst1))./mean(err(ml_lst1))...
    mean(concdata(ml_lst2).*err(ml_lst2))./mean(err(ml_lst2))];

if(~isempty(stim))
    GSS_model.model.T=@(k)calcTk(stim,k,AddReg);
else
    GSS_model.model.T=@(k)calcTk(-12,k,AddReg);
end
    Arg.type = 'state';                                 % inference type (state estimation)
    Arg.tag = 'State estimation for GLM system.';       % arbitrary ID tag
    Arg.model = GSS_model.model;                                % GSSM data structure of external system
    GSS_model.InfDS = geninfds(Arg);  
    
    if(isempty(concdata))
        [X_k,P_k,pNoise, oNoise, InternalVariablesDS]=ekf_k(X_k,P_k,GSS_model.pNoise,GSS_model.oNoise,data*10,[],time,GSS_model.InfDS);
    else
        [X_k,P_k,pNoise, oNoise, InternalVariablesDS]=ekf_k(X_k,P_k,GSS_model.pNoise,GSS_model.oNoise,concdata*10,[],time,GSS_model.InfDS);
    end
      
    Xh=zeros(size(X_k));
    
    lstBeta=GSS_model.model.lstBeta(1:3:end);
    Xh(lstBeta)=X_k(lstBeta);
    Yh_k=feval(GSS_model.model.hfun,GSS_model.model,Xh,0,time);
    
    if(isempty(concdata))
        err=abs(Yh_k-data*10);
    else
        err=abs(Yh_k-concdata*10);    
    end
    err(find(err<1E-3))=1E-3;
    err=1./err;
    T=Xh(lstBeta(:))./diag(P_k(lstBeta,lstBeta)/100).^0.5/10;
    %T=Xh'*inv(P_k).^0.5;
    %T=T(GSS_model.model.lstBeta)';
    addData_gssmGUI(Yh_k/10,Xh(lstBeta)/10,T,time,stim);
    
    figurehandle=findobj('tag','cw6figure');
    Cw6_data = get(figurehandle,'UserData');
    
    if(~isfield(Cw6_data.data,'X'))
        Cw6_data.data.X=[];
    end
    
    Cw6_data.data.X=[Cw6_data.data.X Xh(lstBeta)];
    set(figurehandle,'UserData',Cw6_data);
    

return
