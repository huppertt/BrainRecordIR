function varargout = Cw6(varargin)
% CW6 M-file for Cw6.fig
%      CW6, by itself, creates a new CW6 or raises the existing
%      singleton*.
%
%      H = CW6 returns the handle to a new CW6 or the handle to
%      the existing singleton*.
%
%      CW6('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CW6.M with the given input arguments.
%
%      CW6('Property','Value',...) creates a new CW6 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Cw6_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Cw6_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help Cw6

% Last Modified by GUIDE v2.5 16-May-2008 16:07:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Cw6_OpeningFcn, ...
    'gui_OutputFcn',  @Cw6_OutputFcn, ...
    'gui_LayoutFcn',  [], ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
        gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


function varargout = Cw6_OutputFcn(varargin)

if nargout>0
    varargout{1:nargout}=1;
end

return

% --- Executes just before Cw6 is made visible.
function Cw6_OpeningFcn(hObject, eventdata, handles, varargin)

Splash=LaunchSplash('Splash.jpg');
try
    Splash.setVisible(true);

    label=Splash.getContentPane;
    label=get(label(1),'Components');
    label(1).setText('Loading configuration file...');

    guidata(hObject, handles);

    loadCw6ConfigFile(handles);

    label(1).setText('Loading GUI...');
    handles=LayOutFunction(handles);
    
    label(1).setText('Initializing system...');
    Cw6_BackEnd('Initialize',handles);
    
    set(handles.cw6figure,'visible','on');
    
    global PROBE_DIR;
    if(exist([PROBE_DIR filesep 'RealTimeModules'])==0)
        set(handles.RTProcessing,'enable','off');
    end
    
    h=findobj(handles.cw6figure);
    for idx=1:length(h); 
        try; set(h(idx),'enable','off'); end;
    end;
    set(handles.RegSubj_Menu,'enable','on');
    set(handles.File_Menu,'enable','on');
    set(handles.Help_Menu_Outer,'enable','on');
    set(handles.Help_Menu,'enable','on');
    set(handles.About_Menu,'enable','on');
    set(handles.SystemInfo_Menu,'enable','on');
    set(handles.SubjID,'enable','on');
    set(handles.SaveSettings,'enable','on');
    set(handles.LoadSettings,'enable','on');
    set(handles.ExitProgram,'enable','on');
    set(handles.AddComments,'enable','on');
   set(handles.SubjectHdr,'enable','on');
    
    set(handles.RegSubjContextCallback,'enable','on');
  try;  Splash.dispose(); end  % close the splash screen
catch
    %This destroys the splash if a problem occured
    try;  Splash.dispose(); end  % close the splash screen
end

return


% --- Executes on button press in WindowData.
function WindowData_Callback(hObject, eventdata, handles)



function WindowDataEdit_Callback(hObject, eventdata, handles)
% hObject    handle to WindowDataEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WindowDataEdit as text
%        str2double(get(hObject,'String')) returns contents of WindowDataEdit as a double


% --- Executes during object creation, after setting all properties.
function WindowDataEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WindowDataEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in WhichDisplay.
function WhichDisplay_Callback(hObject, eventdata, handles)
global NUM_LAMBDA;
handles=guihandles(findobj('tag','cw6figure'));
Lambda=get(handles.WhichDisplay,'value');
if(Lambda>NUM_LAMBDA)
    Lambda=Lambda-NUM_LAMBDA;
end
SubjInfo=get(handles.RegistrationInfo,'UserData');
for id=1:length(SubjInfo.SDGdisplay.PlotLst)
    pl=find(SubjInfo.Probe.MeasList(:,1)==SubjInfo.Probe.MeasList(SubjInfo.SDGdisplay.PlotLst(id),1) &...
        SubjInfo.Probe.MeasList(:,2)==SubjInfo.Probe.MeasList(SubjInfo.SDGdisplay.PlotLst(id),2) &...
        SubjInfo.Probe.MeasList(:,4)==Lambda);
    SubjInfo.SDGdisplay.PlotLst(id)=pl;
end
set(handles.RegistrationInfo,'UserData',SubjInfo);
PlotSDG(handles);

labels=get(handles.WhichDisplay,'string');
set(get(handles.MainPlotWindow,'YLabel'),'string',labels(get(handles.WhichDisplay,'value'),:));

% --- Executes on button press in ShowStimulus.
function ShowStimulus_Callback(hObject, eventdata, handles)
% hObject    handle to ShowStimulus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ShowStimulus




% --- Executes during object creation, after setting all properties.
function SDG_PlotWindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SDG_PlotWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate SDG_PlotWindow




% --- Executes on button press in MarkStim.
function MarkStim_Callback(hObject, eventdata, handles)
% hObject    handle to MarkStim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

system=get(handles.AquistionButtons,'Userdata');
if(~strcmp(isrunning(system.MainDevice),'on'))
    return
end
Cw6_data = get(handles.cw6figure,'UserData');
cTpt=Cw6_data.data.raw_t(end);
Cw6_data.data.stim=[Cw6_data.data.stim cTpt];
set(handles.cw6figure,'UserData',Cw6_data);

numStim=str2num(get(handles.NumberStimuliText,'string'));
set(handles.NumberStimuliText,'string',num2str(numStim+1));

return


% --------------------------------------------------------------------
function ExitProgram_Callback(hObject, eventdata, handles)
%TODO: Add Cw6 deconstructors here.

closereq;

% --------------------------------------------------------------------
function ExportFileHdr_Callback(hObject, eventdata, handles)
% hObject    handle to ExportFileHdr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SendDataText_Callback(hObject, eventdata, handles)
% hObject    handle to SendDataText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SendDataHOMER_Callback(hObject, eventdata, handles)
% hObject    handle to SendDataHOMER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

homerhandle=HOMER;
%set(homerhandle,'Position',get(homerhandle,'position')+[1024 0 0 0]);

SubjInfo=get(handles.RegistrationInfo,'UserData');
filename=dir([SubjInfo.SubjID '-' SubjInfo.Study '-scan' num2str(SubjInfo.Scan-1) '-*.nirs']);

HOMerMenu('HOMer_menu_File_Open_Callback',[],[],guihandles(homerhandle),'open',filename.name);

% --------------------------------------------------------------------
function SetDataCOM_Callback(hObject, eventdata, handles)
% hObject    handle to SetDataCOM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SaveSettings_Callback(hObject, eventdata, handles)
% hObject    handle to SaveSettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function LoadSettings_Callback(hObject, eventdata, handles)
% hObject    handle to LoadSettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
return

% --------------------------------------------------------------------
function SubjectHdr_Callback(hObject, eventdata, handles)
% hObject    handle to SubjectHdr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function AddComments_Callback(hObject, eventdata, handles)
f=figure;
set(f,'Toolbar','none');
set(f,'tag','AddComments');
set(f,'Name','Add Comments');
set(f,'NumberTitle','off');

[ExtraHandles.RichText2,ExtraHandles.RichText2Cont]=actxcontrol('RICHTEXT.RichtextCtrl.1');
set(ExtraHandles.RichText2Cont,'units','normalized');
set(ExtraHandles.RichText2Cont,'position',[.05 .15 .9 .8]);

buttonSave=uicontrol('style','pushbutton');
set(buttonSave,'units','normalized');
set(buttonSave,'position',[.75 .02 .2 .1]);
set(buttonSave,'FontSize',16);
set(buttonSave,'string','Save');
set(buttonSave,'Callback','SaveComments(gcbo)');
set(buttonSave,'UserData',ExtraHandles.RichText2);

buttonCancel=uicontrol('style','pushbutton');
set(buttonCancel,'units','normalized');
set(buttonCancel,'position',[.5 .02 .2 .1]);
set(buttonCancel,'FontSize',16);
set(buttonCancel,'string','Cancel');
set(buttonCancel,'Callback','closereq');


