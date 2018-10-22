function [d,t]=getsamples(obj,numbersamples)


try
    [d,t]=getsamples(obj.system,numbersamples);   
catch
    warning('data sampling failed');
    d=[];
    t=[];
end
