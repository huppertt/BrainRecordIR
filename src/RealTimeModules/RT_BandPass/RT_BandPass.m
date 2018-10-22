function varargout = RT_BandPass(varargin)
% RT_BANDPASS M-file for RT_BandPass.fig
%      RT_BANDPASS, by itself, creates a new RT_BANDPASS or raises the existing
%      singleton*.
%
%      H = RT_BANDPASS returns the handle to a new RT_BANDPASS or the handle to
%      the existing singleton*.
%
%      RT_BANDPASS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RT_BANDPASS.M with the given input arguments.
%
%      RT_BANDPASS('Property','Value',...) creates a new RT_BANDPASS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RT_BandPass_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RT_BandPass_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help RT_BandPass

% Last Modified by GUIDE v2.5 07-Mar-2008 14:41:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RT_BandPass_OpeningFcn, ...
                   'gui_OutputFcn',  @RT_BandPass_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before RT_BandPass is made visible.
function RT_BandPass_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RT_BandPass (see VARARGIN)

% Choose default command line output for RT_BandPass
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RT_BandPass wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RT_BandPass_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function LPF_Callback(hObject, eventdata, handles)
% hObject    handle to LPF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LPF as text
%        str2double(get(hObject,'String')) returns contents of LPF as a double



function HPF_Callback(hObject, eventdata, handles)
% hObject    handle to HPF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of HPF as text
%        str2double(get(hObject,'String')) returns contents of HPF as a double


% --- Executes on selection change in FilterOrder.
function FilterOrder_Callback(hObject, eventdata, handles)
% hObject    handle to FilterOrder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns FilterOrder contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FilterOrder


