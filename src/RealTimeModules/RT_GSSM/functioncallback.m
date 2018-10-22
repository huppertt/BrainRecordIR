function [time,data,auxdata,concdata]=rt_gssm(time,data,auxdata,concdata,stim)

persistent GSS_model;

persistent P_k;
persistent X_k;
persistent Yh_k;


if(isempty(data))
    if(isempty(findobj('tag','GSSM_Figure')))
        Plot_GSSM('init',SD);
    else
        Plot_GSSM('reset',NaN);
    end
    GSS_model=init_gssm;
    P_k=zeros(GSS_model.model.statedim,GSS_model.model.statedim);
    X_k=zeros(GSS_model.model.statedim,1);
    Yh_k=zeros(GSS_model.model.obsdim,1);
    
    GSS_model.model.T=@(k)calcTk(stim,k);
    
    Arg.type = 'state';                                 % inference type (state estimation)
    Arg.tag = 'State estimation for GLM system.';       % arbitrary ID tag
    Arg.model = GSS_model.model;                                % GSSM data structure of external system
    GSS_model.InfDS = geninfds(Arg);  
    return;
end


if(~isempty(stim))

    GSS_model.model.T=@(k)calcTk(stim,k);
else
    GSS_model.model.T=@(k)calcTk(-999,k);
end
    Arg.type = 'state';                                 % inference type (state estimation)
    Arg.tag = 'State estimation for GLM system.';       % arbitrary ID tag
    Arg.model = GSS_model.model;                                % GSSM data structure of external system
    GSS_model.InfDS = geninfds(Arg);  
    
    if(isempty(concdata))
        [X_k,P_k]=ekf_k(X_k,P_k,GSS_model.pNoise,GSS_model.oNoise,data,[],time,GSS_model.InfDS);
   else
        [X_k,P_k]=ekf_k(X_k,P_k,GSS_model.pNoise,GSS_model.oNoise,concdata,[],time,GSS_model.InfDS);
    end
    Xh=zeros(size(X_k));
    Xh(GSS_model.model.lstBeta)=X_k(GSS_model.model.lstBeta);
    Yh_k=feval(GSS_model.model.hfun,GSS_model.model,Xh,0,time);  
    Plot_GSSM('addData',NaN,Yh_k,Xh(GSS_model.model.lstBeta),time,stim);


return
