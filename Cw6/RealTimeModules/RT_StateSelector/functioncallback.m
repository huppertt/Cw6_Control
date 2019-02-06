function [time,data,auxdata,concdata]=rt_gssm(time,data,auxdata,concdata,stim)

persistent GSS_model1;
persistent GSS_model2;

persistent P1_k;
persistent X1_k;

persistent P2_k;
persistent X2_k;

persistent Pf_k;
persistent Xf_k;

persistent Yh_k;



if(isempty(data))
    GSS_model1=init_gssm_stateswitch('A');
    P1_k=.1*eye(GSS_model1.model.statedim,GSS_model1.model.statedim);
    X1_k=zeros(GSS_model1.model.statedim,1);
    Yh_k=zeros(GSS_model1.model.obsdim,1);
    GSS_model1.model.T=@(k)calcTk(stim,k);
    
    Arg.type = 'state';                                 % inference type (state estimation)
    Arg.tag = 'State estimation for GLM system.';       % arbitrary ID tag
    Arg.model = GSS_model1.model;                                % GSSM data structure of external system
    GSS_model1.InfDS = geninfds(Arg);  
    
    %Model 2
    GSS_model2=init_gssm_stateswitch('B');
    P2_k=.1*eye(GSS_model2.model.statedim,GSS_model2.model.statedim);
    X2_k=zeros(GSS_model2.model.statedim,1);
    
    Xf_k=zeros(size(X2_k(GSS_model1.model.lstBeta)));
    Pf_k=zeros(size(P2_k(GSS_model1.model.lstBeta,GSS_model1.model.lstBeta)));
    
    GSS_model2.model.T=@(k)calcTk(stim,k);
    
    Arg.type = 'state';                                 % inference type (state estimation)
    Arg.tag = 'State estimation for GLM system.';       % arbitrary ID tag
    Arg.model = GSS_model2.model;                                % GSSM data structure of external system
    GSS_model2.InfDS = geninfds(Arg);  
    
    return;
end


if(~isempty(stim))
    GSS_model1.model.T=@(k)calcTk(stim,k);
    GSS_model2.model.T=@(k)calcTk(stim,k);
else
    GSS_model1.model.T=@(k)calcTk(-999,k);
    GSS_model2.model.T=@(k)calcTk(-999,k);
end
    Arg.type = 'state';                                 % inference type (state estimation)
    Arg.tag = 'State estimation for GLM system.';       % arbitrary ID tag
    Arg.model = GSS_model1.model;                                % GSSM data structure of external system
    GSS_model1.InfDS = geninfds(Arg);  
    
    Arg.model = GSS_model2.model;                                % GSSM data structure of external system
    GSS_model2.InfDS = geninfds(Arg);  
    
    if(isempty(concdata))
        [X1_k,P1_k]=ekf_k(X1_k,P1_k,GSS_model1.pNoise,GSS_model1.oNoise,data*10,[],time,GSS_model1.InfDS);
        [X2_k,P2_k]=ekf_k(X2_k,P2_k,GSS_model2.pNoise,GSS_model2.oNoise,data*10,[],time,GSS_model2.InfDS);
    else
        [X1_k,P1_k]=ekf_k(X1_k,P1_k,GSS_model1.pNoise,GSS_model1.oNoise,concdata*10,[],time,GSS_model1.InfDS);
        [X2_k,P2_k]=ekf_k(X2_k,P2_k,GSS_model2.pNoise,GSS_model2.oNoise,concdata*10,[],time,GSS_model2.InfDS);
    end
    
    [Xf_k,Pf_k,G]=StateVectorFusion(X1_k(GSS_model1.model.lstBeta),X2_k(GSS_model2.model.lstBeta),...
        P1_k(GSS_model1.model.lstBeta,GSS_model1.model.lstBeta),...
        P2_k(GSS_model2.model.lstBeta,GSS_model2.model.lstBeta),Xf_k,Pf_k);
disp(G)

return
