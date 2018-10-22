function stop(obj)
%This is the parent function for starting a TechEn device

try
    stop(obj.system);   
catch
    warning('stop failed');
end