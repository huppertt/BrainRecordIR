function start(obj)
%This is the parent function for starting a TechEn device

try
    start(obj.system);   
catch
    warning('Start failed');
end

