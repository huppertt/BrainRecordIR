function obj = TechEnDAQ(deviceName,deviceID)
%This function creates the initial
%instance of a TechEn device.  Only one
%instance may exist.  

%The currently supported TechEn devices are:
%   Simulator-  a data aquistion simulator
%   Cw6
%   NIRS2

% persistent singleton;
% 
% if(strcmp(singleton,deviceID))
%     warning('Device ID already assigned');
%     device=[];
%     return
% else
%     singleton=deviceID;
% end


switch(deviceName)
    case('Simulator')
        device.system=simulator;
        device.name='simulator';
    case('Cw6');   
       % cw6_system=actxcontrol('CW6CONTROLACTIVEX.Cw6ControlactivexCtrl.1',[0 0 .01 .01]);
        device.system=CW6System;
        device.name='cw6'
    case('NIRS2')
        device.system=nirs2;
        device.name='nirs2';
    otherwise
        warning('Device Name not supported');
        device=[];
        return;
end


if(~isa(device,'TechEnDAQ'))
    obj=class(device,'TechEnDAQ');
else
    obj=device;
end

return