function flag=isrunning(foo)
global Cw6device;
flag=Cw6device.isrunning;

if(flag==1)
    flag='on';
else
    flag='off';
end

return