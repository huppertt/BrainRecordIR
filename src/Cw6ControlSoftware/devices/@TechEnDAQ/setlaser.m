function changelaser(obj,laser,boolstate)

if(length(laser)>1 & length(boolstate)~=length(laser))
    boolstate=boolstate(1)*ones(size(laser));
end

for idx=1:length(laser)
    try
        setlaser(obj.system,laser(idx),boolstate(idx));   
    catch
         warning('laser change failed');
    end
end

return