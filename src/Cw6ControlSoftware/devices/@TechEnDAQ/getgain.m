function states=getgain(obj,detIdx)

if(~exist('detIdx'))
    detIdx=[];
end
    try
        states=getgain(obj.system,detIdx);   
    catch
        states=[];
        warning('get detector value failed');
    end


return