function simulatordevice=simulator
%Class constructor for simulator

global simulatordevice;
global NUM_SRC;
global NUM_DET;

simulatordevice.devicehandle=createsimulator;

%Data Management
simulatordevice.data = [];
simulatordevice.data_t = [];
simulatordevice.lastcalled=0;

simulatordevice.isrunning=false;

simulatordevice.SystemType='Simulator';
simulatordevice.SystemInfo.NumLasers=NUM_SRC;
simulatordevice.SystemInfo.NumDetectors=NUM_DET;

simulatordevice.SystemInfo.MeasurementLst=getdeviceML;
simulatordevice.SystemInfo.NUMMEAS=size(simulatordevice.SystemInfo.MeasurementLst,1);


simulatordevice.System.LaserStates=false(simulatordevice.SystemInfo.NumLasers,1);
simulatordevice.System.DetGains=zeros(simulatordevice.SystemInfo.NumDetectors,1);
simulatordevice.DAQ.handle=makeDAQhandle;

if(~isa(simulatordevice,'simulator'))
    simulatordevice=class(simulatordevice,'simulator');
end
writemsg(simulatordevice,'ready to start');

return


function handle=createsimulator
handle=figure('tag','simulatorfigure');
actx=actxcontrol('RICHTEXT.RichtextCtrl.1',[50 50 350 350],handle);
set(handle,'UserData',actx);
return

function handle=makeDAQhandle
%This function makes the handle to the data logger
handle=timer('TimerFcn',@mycallback, 'Period', 0.1,'TasksToExecute',600,'ExecutionMode','fixedRate');
return

function mycallback(varargin)
global simulatordevice;

return

        



