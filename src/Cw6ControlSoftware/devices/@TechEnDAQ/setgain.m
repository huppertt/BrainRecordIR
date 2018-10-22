function setgain(obj,det,gains)

if(length(det)>1 & length(gains)~=length(det))
    gains=gains(1)*ones(size(det));
end

for idx=1:length(det)
    try
        setgain(obj.system,gains(idx),det(idx));   
    catch
         warning('gain change failed');
    end
end

return