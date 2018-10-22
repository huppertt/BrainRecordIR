function [time,data,auxdata,concdata]=onlinefilter(time,data,auxdata,concdata,stim)

%This function preforms a bandpass filter of the data (aux data is not%used, but all RT functions need this form)

persistent RTfilter;

if(isempty(data))
    RTfilter=[];
    return;
end

if(isempty(RTfilter))
    nmeas=size(data,1);   
    %For now hard code it
    RTfilter.filterOrder=4+1;
    RTfilter.x=zeros(nmeas,RTfilter.filterOrder);
    RTfilter.x(:,1:RTfilter.filterOrder)=repmat(data,1,RTfilter.filterOrder); 
    
    RTfilter.y=zeros(nmeas,RTfilter.filterOrder-1);
    RTfilter.y(:,1:RTfilter.filterOrder-1)=repmat(data,1,RTfilter.filterOrder-1); 
    
    [B,A]=butter(RTfilter.filterOrder-1,.25);
    RTfilter.filterkernelB=repmat(B(end:-1:1)/A(1),nmeas,1);
    RTfilter.filterkernelA=repmat(A(end:-1:2)/A(1),nmeas,1);
end

RTfilter.x(:,[1:RTfilter.filterOrder-1])=RTfilter.x(:,[2:RTfilter.filterOrder]);
RTfilter.x(:,RTfilter.filterOrder)=data;

data=sum(RTfilter.filterkernelB.*RTfilter.x,2)-sum(RTfilter.filterkernelA.*RTfilter.y,2);

RTfilter.y(:,[1:RTfilter.filterOrder-2])=RTfilter.y(:,[2:RTfilter.filterOrder-1]);
RTfilter.y(:,RTfilter.filterOrder-1)=data;

return
