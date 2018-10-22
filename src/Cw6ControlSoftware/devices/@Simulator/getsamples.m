function [d,t]=getsamples(foo,numbersamples);
global simulatordevice;

tasks=simulatordevice.lastcalled+1:simulatordevice.lastcalled+numbersamples;
simulatordevice.lastcalled=get(simulatordevice.DAQ.handle,'TasksExecuted');
t=get(simulatordevice.DAQ.handle,'Period')*tasks;
d=rand(size(simulatordevice.SystemInfo.MeasurementLst,1),numbersamples);


return
