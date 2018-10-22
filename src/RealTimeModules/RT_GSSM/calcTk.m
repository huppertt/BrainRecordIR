function T=calcTk(stim,k)

T=sum((k-stim).^2.*exp(-(k-stim).^2/12));
% if(k-stim(end)<10)
%     T=1;
% else
%     T=0;
% end


return