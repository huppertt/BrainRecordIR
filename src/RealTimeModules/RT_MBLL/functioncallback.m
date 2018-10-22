function [currenttime,currentdata,auxdata,concdata]=processRTMBLL(currenttime,currentdata,auxdata,concdata,stim)

handles=guihandles(findobj('tag','cw6figure'));
SubjInfo=get(handles.RegistrationInfo,'UserData');
Measlist=SubjInfo.Probe.MeasList;

persistent kalmanparameters_MBLL;
persistent invE;


if(isempty(currentdata))
    kalmanparameters_MBLL=[];
    return;
end


if(isempty(invE))
    E=GetExtinctions(SubjInfo.Probe.Lambda);
    E=E(1:2,1:2);
    invE=inv(E);
end

if(isempty(kalmanparameters_MBLL))  
    R=.1;
    Q=1E-8;  
    nmeas=size(currentdata,1);
    
    %Initial implementation
    kalmanparameters_MBLL.xk=currentdata(:,1);
    kalmanparameters_MBLL.pk=eye(nmeas);
    kalmanparameters_MBLL.H=eye(nmeas);
    kalmanparameters_MBLL.F=eye(nmeas);
    kalmanparameters_MBLL.R=R*eye(nmeas);
    kalmanparameters_MBLL.Q=Q*eye(nmeas);
    kalmanparameters_MBLL.I=eye(nmeas);
end

Io=zeros(size(currentdata));

for tIdx=1:size(currentdata,2)
    [kalmanparameters_MBLL, Io(:,tIdx)]=RT_kalmanfilter(currentdata(:,tIdx),kalmanparameters_MBLL);
    figure(2);
    plot(Io);
end

dOD=-log(currentdata./Io);

lst1=find(Measlist(:,4)==1);
lst2=find(Measlist(:,4)==2);

for tIdx=1:size(currentdata,2)
    concdata(:,:,tIdx)=(invE*[dOD(lst1,tIdx) dOD(lst2,tIdx)]')';
end

concdata=reshape(concdata,[],size(currentdata,2))*1E6;
return
