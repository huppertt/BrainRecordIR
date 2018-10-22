function obj = CW6System
%This function creates the initial
%instance of a TechEn device.  Only one
%instance may exist.  

device.name='Cw6';
%device.instrument=actxcontrol('CW6CONTROLACTIVEX.Cw6ControlactivexCtrl.1',[0 0 .01 .01]);

if(~isa(device,'CW6System'))
    obj=class(device,'CW6System');
else
    obj=device;
end

return