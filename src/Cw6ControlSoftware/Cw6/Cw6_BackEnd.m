function Cw6_BackEnd(varargin)

if ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK
    
        try
		    [varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
	    catch
            disp(lasterr); 
        end

end

return


function Initialize(handles)
%This function intializes the 
global SYSTEM_TYPE;

%Make the system structure
system.MainDevice=TechEnDAQ(SYSTEM_TYPE,'0');
system.AuxDevice=[];
system.MainTimer=timer('TimerFcn',@NIRS_timer_main_callback, 'Period', 0.5,...
    'TasksToExecute',72000,'ExecutionMode','fixedRate','BusyMode','Drop');  %Will run for up to an hour

initialize(system.MainDevice);
%the remainder of the initialization needs to wait for the probe design

set(handles.AquistionButtons,'Userdata',system);

return


function TestTime_Callback(hObject, eventdata, handles)
% hObject    handle to TestTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TestTime as text
%        str2double(get(hObject,'String')) returns contents of TestTime as a double

% --- Executes on button press in FreeRunCheckBox.
function FreeRunCheckBox_Callback(hObject, eventdata, handles)

if(get(hObject,'value'))
    set(handles.TestTime,'enable','off');
else
    set(handles.TestTime,'enable','on');
end


% --- Executes on button press in StartAQ.
function StartAQ_Callback(hObject, eventdata, handles)
%This function runs everything

system=get(handles.AquistionButtons,'Userdata');

if(~validatesystem(system))
    warndlg('Unable to start system');
    return
end

usetime=0;
if(~get(handles.FreeRunCheckBox,'value'))

    ScanTime=str2num(get(handles.TestTime,'string'));
    if(~isempty(ScanTime))
      
        aqtimer=timer('TimerFcn',@localStopTimer,'tag','runtimer',...
            'TasksToExecute',1,'Period',.2,'StartDelay',ScanTime+1);
        usetime=1;
    else
        set(handles.FreeRunCheckBox,'value',1)
    end
else
    ScanTime=7200;  %Two-hour max
end

ProgressBar=get(findobj('tag','Cw6Progress'),'UserData');
set(ProgressBar,'Maximum',ScanTime);
set(ProgressBar,'Value',0);

set(system.MainTimer,'TasksToExecute',ceil(ScanTime/get(system.MainTimer,'Period'))+2);

set(handles.FreeRunCheckBox,'enable','off');
set(handles.StartAQ,'enable','off');
set(handles.StopAQ,'enable','on');

%Save a copy of the temp data before you erase it
Cw6_data=get(handles.cw6figure,'UserData');
SubjInfo=get(handles.RegistrationInfo,'UserData');
save('Temp','Cw6_data','SubjInfo');

%Reset Data
Cw6_data.data.raw=[];
Cw6_data.data.raw_t=[];
Cw6_data.data.conc=[];
Cw6_data.data.aux=[];
Cw6_data.data.stim=[];

[time,data,auxdata,concdata]=processRTfunctions([],[],[],[]);

set(handles.NumberStimuliText,'string','0');

set(handles.cw6figure,'UserData',Cw6_data);

axes(handles.MainPlotWindow);
cla;
set(handles.MainPlotWindow,'UserData',[]);

SubjInfo=get(handles.RegistrationInfo,'UserData');
SD=SubjInfo.Probe;
ml_Device=getML(system.MainDevice);
ml_probe=SD.MeasList;
SD.mlMap=zeros(size(ml_probe,1),1);

for idx=1:size(ml_probe,1); 
    SrcIdx=ml_probe(idx,1);
    DetIdx=ml_probe(idx,2);
    LambdaIdx=ml_probe(idx,4);
    LaserIdx=SD.LaserPos(SrcIdx,LambdaIdx);
    SD.mlMap(idx)=find(ml_Device(:,1)==LaserIdx & ml_Device(:,2)==DetIdx);
end
SD.DataToMLMap=SendML2Cw6(ml_probe,SD,ml_Device);

SubjInfo.Probe=SD;
set(handles.RegistrationInfo,'UserData',SubjInfo);


%initialize(system.MainDevice);
if(~isempty(system.AuxDevice))
    start(system.AuxDevice);
end
tic;
start(system.MainDevice);
start(system.MainTimer);

if(usetime)
    start(aqtimer);
end


return



% --- Executes on button press in StopAQ.
function StopAQ_Callback(hObject, eventdata, handles)
% hObject    handle to StopAQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

system=get(handles.AquistionButtons,'Userdata');
disp(toc);
try; stop(system.MainTimer); end;
try; stop(system.AuxDevice); end;
try; stop(system.MainDevice); end;
stop(timerfind);

pause(1);

delete(timerfind('tag','runtimer'));
set(handles.FreeRunCheckBox,'enable','on');
set(handles.StartAQ,'enable','on');
set(handles.StopAQ,'enable','off');

SubjInfo=get(handles.RegistrationInfo,'UserData');
Cw6_data=get(handles.cw6figure,'UserData');
saveNIRSData(Cw6_data,SubjInfo);

SubjInfo.Scan=SubjInfo.Scan+1;
SubjInfo.CurrentFileName=[SubjInfo.SubjID '-' SubjInfo.Study '-scan' num2str(SubjInfo.Scan) '-<DateTime>'];
set((handles.CurDataFileName),'string',SubjInfo.CurrentFileName);
set(handles.RegistrationInfo,'UserData',SubjInfo);


function SetGain(varagin)

global NUM_DET;

handles=guihandles(findobj('tag','cw6figure'));
system=get(handles.AquistionButtons,'Userdata');
Javahandles=get(findobj('tag','DetTabContainer'),'UserData');

if(~isfield(system,'AQSettings'))
    system.AQSettings.Gains=zeros(NUM_DET,1);
elseif(~isfield(system.AQSettings,'Gains'))
    system.AQSettings.Gains=zeros(NUM_DET,1);
end

GainsOld=system.AQSettings.Gains;
[nPanels,nDet]=size(Javahandles.spinner);
cnt=1;

for Tab=1:nPanels
    for Det=1:nDet
        system.AQSettings.Gains(cnt)=get(Javahandles.spinner(Tab,Det),'Value');
        cnt=cnt+1;
    end
end

lstchanged=find(system.AQSettings.Gains-GainsOld~=0);
set(handles.AquistionButtons,'Userdata',system);

for idx=1:length(lstchanged)
    setgain(system.MainDevice,lstchanged(idx),system.AQSettings.Gains(lstchanged(idx)));
end


return

