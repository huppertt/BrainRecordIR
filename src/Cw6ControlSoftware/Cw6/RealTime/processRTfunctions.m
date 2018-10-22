function [time,data,auxdata,concdata,stim]=processRTfunctions(time,data,auxdata,stim)

cw6figure=findobj('tag','cw6figure');
cw6info=get(cw6figure,'UserData');

if isfield(cw6info,'RTmodules')
    functionlst=cw6info.RTmodules;
else
    functionlst={};
end
% persistent kalmanparameters_MBLL;
%     
% Io=zeros(size(data,1),1);
% if(isempty(data))
%     kalmanparameters_MBLL=[];
% else
% 
%     if(isempty(kalmanparameters_MBLL))
%         R=.01;
%         Q=1E-6;
%         nmeas=size(data,1);
% 
%         %Initial implementation
%         kalmanparameters_MBLL.xk=data(:,1);
%         kalmanparameters_MBLL.pk=eye(nmeas);
%         kalmanparameters_MBLL.H=eye(nmeas);
%         kalmanparameters_MBLL.F=eye(nmeas);
%         kalmanparameters_MBLL.R=R*eye(nmeas);
%         kalmanparameters_MBLL.Q=Q*eye(nmeas);
%         kalmanparameters_MBLL.I=eye(nmeas);
%     end
%     
%     for tIdx=1:size(data,2)
%         [kalmanparameters_MBLL, Io]=RT_kalmanfilter(data(:,tIdx),kalmanparameters_MBLL);
%     end
% end

concdata=[];

stim=catchstim(stim,auxdata,time);

for idx=1:length(functionlst)
        [time,data,auxdata,concdata]=feval(functionlst{idx}.fhandle,time,...
                data,auxdata,concdata,stim);

end

return
