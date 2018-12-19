function initializeApp(app)

global BrainRecordIRApp;
 BrainRecordIRApp = app;

% load a config file specifying the instrument and default folders
folder=fileparts(which('BrainRecordIR.mlapp'));
if(exist(fullfile(folder,'System.config'),'file'))
    system=[];
    load(fullfile(folder,'System.config'),'-MAT');
   
else
   disp('Default configuration not found: restoring');
   system=restore_default_settings('Simulator');
end

app.SystemType=system.Type;

app.Device=NIRSinstrument(app.SystemType);
% initialize the instrument class

%% TODO-  change to allow enum selection based on instrument
fs=[num2str(app.Device.sample_rate) 'Hz'];
BrainRecordIRApp.SampleRateDropDown.Items={fs};
BrainRecordIRApp.SampleRateDropDown.Value=fs;

if(strcmp(system.Type,'Simulator'))
    comport='-------';
elseif((strcmp(system.Type,'Simulator')) | (strcmp(system.Type,'CW6')) | (strcmp(system.Type,'Cw7')))
    if(ismac)
        c=dir('/dev/cu.usbserial-*');
        if(~isempty(c))
            comport=c(1).name;
        else
            comport='?';
        end
    else
        comport='COM1';  % TODO
    end
else
    comport='??';
end
BrainRecordIRApp.ConnectionEditField.Value=comport;
SystemMessage(['Initializing ' char(system.Type) ' : ' comport]);

app.Folders=system.Folders;


%% Laser controls for easy access
app.handles.Lasers=cell(16,7);
app.handles.Lasers{1,1}=app.Src1Panel;
app.handles.Lasers{1,2}=app.SpinnerS_1;
app.handles.Lasers{1,3}=app.SwitchS_1;
app.handles.Lasers{1,4}=app.LampS_1;
app.handles.Lasers{1,5}=app.SpinnerS_2;
app.handles.Lasers{1,6}=app.SwitchS_2;
app.handles.Lasers{1,7}=app.LampS_2;
 
app.handles.Lasers{2,1}=app.Src2Panel;
app.handles.Lasers{2,2}=app.SpinnerS_3;
app.handles.Lasers{2,3}=app.SwitchS_3;
app.handles.Lasers{2,4}=app.LampS_3;
app.handles.Lasers{2,5}=app.SpinnerS_4;
app.handles.Lasers{2,6}=app.SwitchS_4;
app.handles.Lasers{2,7}=app.LampS_4;
 
app.handles.Lasers{3,1}=app.Src3Panel;
app.handles.Lasers{3,2}=app.SpinnerS_5;
app.handles.Lasers{3,3}=app.SwitchS_5;
app.handles.Lasers{3,4}=app.LampS_5;
app.handles.Lasers{3,5}=app.SpinnerS_6;
app.handles.Lasers{3,6}=app.SwitchS_6;
app.handles.Lasers{3,7}=app.LampS_6;
 
app.handles.Lasers{4,1}=app.Src4Panel;
app.handles.Lasers{4,2}=app.SpinnerS_7;
app.handles.Lasers{4,3}=app.SwitchS_7;
app.handles.Lasers{4,4}=app.LampS_7;
app.handles.Lasers{4,5}=app.SpinnerS_8;
app.handles.Lasers{4,6}=app.SwitchS_8;
app.handles.Lasers{4,7}=app.LampS_8;
 
app.handles.Lasers{5,1}=app.Src5Panel;
app.handles.Lasers{5,2}=app.SpinnerS_9;
app.handles.Lasers{5,3}=app.SwitchS_9;
app.handles.Lasers{5,4}=app.LampS_9;
app.handles.Lasers{5,5}=app.SpinnerS_10;
app.handles.Lasers{5,6}=app.SwitchS_10;
app.handles.Lasers{5,7}=app.LampS_10;
 
app.handles.Lasers{6,1}=app.Src6Panel;
app.handles.Lasers{6,2}=app.SpinnerS_11;
app.handles.Lasers{6,3}=app.SwitchS_11;
app.handles.Lasers{6,4}=app.LampS_11;
app.handles.Lasers{6,5}=app.SpinnerS_12;
app.handles.Lasers{6,6}=app.SwitchS_12;
app.handles.Lasers{6,7}=app.LampS_12;
 
app.handles.Lasers{7,1}=app.Src7Panel;
app.handles.Lasers{7,2}=app.SpinnerS_13;
app.handles.Lasers{7,3}=app.SwitchS_13;
app.handles.Lasers{7,4}=app.LampS_13;
app.handles.Lasers{7,5}=app.SpinnerS_14;
app.handles.Lasers{7,6}=app.SwitchS_14;
app.handles.Lasers{7,7}=app.LampS_14;
 
app.handles.Lasers{8,1}=app.Src8Panel;
app.handles.Lasers{8,2}=app.SpinnerS_15;
app.handles.Lasers{8,3}=app.SwitchS_15;
app.handles.Lasers{8,4}=app.LampS_15;
app.handles.Lasers{8,5}=app.SpinnerS_16;
app.handles.Lasers{8,6}=app.SwitchS_16;
app.handles.Lasers{8,7}=app.LampS_16;
 
app.handles.Lasers{9,1}=app.Src9Panel;
app.handles.Lasers{9,2}=app.SpinnerS_17;
app.handles.Lasers{9,3}=app.SwitchS_17;
app.handles.Lasers{9,4}=app.LampS_17;
app.handles.Lasers{9,5}=app.SpinnerS_18;
app.handles.Lasers{9,6}=app.SwitchS_18;
app.handles.Lasers{9,7}=app.LampS_18;
 
app.handles.Lasers{10,1}=app.Src10Panel;
app.handles.Lasers{10,2}=app.SpinnerS_19;
app.handles.Lasers{10,3}=app.SwitchS_19;
app.handles.Lasers{10,4}=app.LampS_19;
app.handles.Lasers{10,5}=app.SpinnerS_20;
app.handles.Lasers{10,6}=app.SwitchS_20;
app.handles.Lasers{10,7}=app.LampS_20;
 
app.handles.Lasers{11,1}=app.Src11Panel;
app.handles.Lasers{11,2}=app.SpinnerS_21;
app.handles.Lasers{11,3}=app.SwitchS_21;
app.handles.Lasers{11,4}=app.LampS_21;
app.handles.Lasers{11,5}=app.SpinnerS_22;
app.handles.Lasers{11,6}=app.SwitchS_22;
app.handles.Lasers{11,7}=app.LampS_22;
 
app.handles.Lasers{12,1}=app.Src12Panel;
app.handles.Lasers{12,2}=app.SpinnerS_23;
app.handles.Lasers{12,3}=app.SwitchS_23;
app.handles.Lasers{12,4}=app.LampS_23;
app.handles.Lasers{12,5}=app.SpinnerS_24;
app.handles.Lasers{12,6}=app.SwitchS_24;
app.handles.Lasers{12,7}=app.LampS_24;
 
app.handles.Lasers{13,1}=app.Src13Panel;
app.handles.Lasers{13,2}=app.SpinnerS_25;
app.handles.Lasers{13,3}=app.SwitchS_25;
app.handles.Lasers{13,4}=app.LampS_25;
app.handles.Lasers{13,5}=app.SpinnerS_26;
app.handles.Lasers{13,6}=app.SwitchS_26;
app.handles.Lasers{13,7}=app.LampS_26;
 
app.handles.Lasers{14,1}=app.Src14Panel;
app.handles.Lasers{14,2}=app.SpinnerS_27;
app.handles.Lasers{14,3}=app.SwitchS_27;
app.handles.Lasers{14,4}=app.LampS_27;
app.handles.Lasers{14,5}=app.SpinnerS_28;
app.handles.Lasers{14,6}=app.SwitchS_28;
app.handles.Lasers{14,7}=app.LampS_28;
 
app.handles.Lasers{15,1}=app.Src15Panel;
app.handles.Lasers{15,2}=app.SpinnerS_29;
app.handles.Lasers{15,3}=app.SwitchS_29;
app.handles.Lasers{15,4}=app.LampS_29;
app.handles.Lasers{15,5}=app.SpinnerS_30;
app.handles.Lasers{15,6}=app.SwitchS_30;
app.handles.Lasers{15,7}=app.LampS_30;
 
app.handles.Lasers{16,1}=app.Src16Panel;
app.handles.Lasers{16,2}=app.SpinnerS_31;
app.handles.Lasers{16,3}=app.SwitchS_31;
app.handles.Lasers{16,4}=app.LampS_31;
app.handles.Lasers{16,5}=app.SpinnerS_32;
app.handles.Lasers{16,6}=app.SwitchS_32;
app.handles.Lasers{16,7}=app.LampS_32;
 
if(~system.Lasers.Adjustable)
    for i=1:size(app.handles.Lasers,1)
       app.handles.Lasers{i,3}.Enable=false;
       app.handles.Lasers{i,6}.Enable=false;
    end
end

for i=1:size(app.handles.Lasers,1)
    app.handles.Lasers{i,1}.UserData=i;
    app.handles.Lasers{i,2}.Limits=system.Lasers.GainRange;
    app.handles.Lasers{i,5}.Limits=system.Lasers.GainRange;
    app.handles.Lasers{i,2}.ValueChangedFcn=@UpdateSourceSpinner;
    app.handles.Lasers{i,2}.UserData=(i-1)*2+1;
    app.handles.Lasers{i,5}.ValueChangedFcn=@UpdateSourceSpinner;
    app.handles.Lasers{i,5}.UserData=(i-1)*2+2;
    app.handles.Lasers{i,3}.ValueChangedFcn=@UpdateSourceToggle;
    app.handles.Lasers{i,3}.UserData=(i-1)*2+1;
    app.handles.Lasers{i,6}.ValueChangedFcn=@UpdateSourceToggle;
    app.handles.Lasers{i,6}.UserData=(i-1)*2+2;
    
    app.handles.Lasers{i,4}.Color=[.6 .6 .6];
    app.handles.Lasers{i,7}.Color=[.6 .6 .6];
    app.handles.Lasers{i,3}.Value='Off';
    app.handles.Lasers{i,6}.Value='Off';
end

%% detector handles
app.handles.Detectors=cell(32,4);
app.handles.Detectors{1,1}=app.PanelD_1;
app.handles.Detectors{1,2}=app.SliderD_1;
app.handles.Detectors{1,3}=app.EditFieldD_1;
app.handles.Detectors{1,4}=app.LampD_1;
 
app.handles.Detectors{2,1}=app.PanelD_2;
app.handles.Detectors{2,2}=app.SliderD_2;
app.handles.Detectors{2,3}=app.EditFieldD_2;
app.handles.Detectors{2,4}=app.LampD_2;
 
app.handles.Detectors{3,1}=app.PanelD_3;
app.handles.Detectors{3,2}=app.SliderD_3;
app.handles.Detectors{3,3}=app.EditFieldD_3;
app.handles.Detectors{3,4}=app.LampD_3;
 
app.handles.Detectors{4,1}=app.PanelD_4;
app.handles.Detectors{4,2}=app.SliderD_4;
app.handles.Detectors{4,3}=app.EditFieldD_4;
app.handles.Detectors{4,4}=app.LampD_4;
 
app.handles.Detectors{5,1}=app.PanelD_5;
app.handles.Detectors{5,2}=app.SliderD_5;
app.handles.Detectors{5,3}=app.EditFieldD_5;
app.handles.Detectors{5,4}=app.LampD_5;
 
app.handles.Detectors{6,1}=app.PanelD_6;
app.handles.Detectors{6,2}=app.SliderD_6;
app.handles.Detectors{6,3}=app.EditFieldD_6;
app.handles.Detectors{6,4}=app.LampD_6;
 
app.handles.Detectors{7,1}=app.PanelD_7;
app.handles.Detectors{7,2}=app.SliderD_7;
app.handles.Detectors{7,3}=app.EditFieldD_7;
app.handles.Detectors{7,4}=app.LampD_7;
 
app.handles.Detectors{8,1}=app.PanelD_8;
app.handles.Detectors{8,2}=app.SliderD_8;
app.handles.Detectors{8,3}=app.EditFieldD_8;
app.handles.Detectors{8,4}=app.LampD_8;
 
app.handles.Detectors{9,1}=app.PanelD_9;
app.handles.Detectors{9,2}=app.SliderD_9;
app.handles.Detectors{9,3}=app.EditFieldD_9;
app.handles.Detectors{9,4}=app.LampD_9;
 
app.handles.Detectors{10,1}=app.PanelD_10;
app.handles.Detectors{10,2}=app.SliderD_10;
app.handles.Detectors{10,3}=app.EditFieldD_10;
app.handles.Detectors{10,4}=app.LampD_10;
 
app.handles.Detectors{11,1}=app.PanelD_11;
app.handles.Detectors{11,2}=app.SliderD_11;
app.handles.Detectors{11,3}=app.EditFieldD_11;
app.handles.Detectors{11,4}=app.LampD_11;
 
app.handles.Detectors{12,1}=app.PanelD_12;
app.handles.Detectors{12,2}=app.SliderD_12;
app.handles.Detectors{12,3}=app.EditFieldD_12;
app.handles.Detectors{12,4}=app.LampD_12;
 
app.handles.Detectors{13,1}=app.PanelD_13;
app.handles.Detectors{13,2}=app.SliderD_13;
app.handles.Detectors{13,3}=app.EditFieldD_13;
app.handles.Detectors{13,4}=app.LampD_13;
 
app.handles.Detectors{14,1}=app.PanelD_14;
app.handles.Detectors{14,2}=app.SliderD_14;
app.handles.Detectors{14,3}=app.EditFieldD_14;
app.handles.Detectors{14,4}=app.LampD_14;
 
app.handles.Detectors{15,1}=app.PanelD_15;
app.handles.Detectors{15,2}=app.SliderD_15;
app.handles.Detectors{15,3}=app.EditFieldD_15;
app.handles.Detectors{15,4}=app.LampD_15;
 
app.handles.Detectors{16,1}=app.PanelD_16;
app.handles.Detectors{16,2}=app.SliderD_16;
app.handles.Detectors{16,3}=app.EditFieldD_16;
app.handles.Detectors{16,4}=app.LampD_16;
 
app.handles.Detectors{17,1}=app.PanelD_17;
app.handles.Detectors{17,2}=app.SliderD_17;
app.handles.Detectors{17,3}=app.EditFieldD_17;
app.handles.Detectors{17,4}=app.LampD_17;
 
app.handles.Detectors{18,1}=app.PanelD_18;
app.handles.Detectors{18,2}=app.SliderD_18;
app.handles.Detectors{18,3}=app.EditFieldD_18;
app.handles.Detectors{18,4}=app.LampD_18;
 
app.handles.Detectors{19,1}=app.PanelD_19;
app.handles.Detectors{19,2}=app.SliderD_19;
app.handles.Detectors{19,3}=app.EditFieldD_19;
app.handles.Detectors{19,4}=app.LampD_19;
 
app.handles.Detectors{20,1}=app.PanelD_20;
app.handles.Detectors{20,2}=app.SliderD_20;
app.handles.Detectors{20,3}=app.EditFieldD_20;
app.handles.Detectors{20,4}=app.LampD_20;
 
app.handles.Detectors{21,1}=app.PanelD_21;
app.handles.Detectors{21,2}=app.SliderD_21;
app.handles.Detectors{21,3}=app.EditFieldD_21;
app.handles.Detectors{21,4}=app.LampD_21;
 
app.handles.Detectors{22,1}=app.PanelD_22;
app.handles.Detectors{22,2}=app.SliderD_22;
app.handles.Detectors{22,3}=app.EditFieldD_22;
app.handles.Detectors{22,4}=app.LampD_22;
 
app.handles.Detectors{23,1}=app.PanelD_23;
app.handles.Detectors{23,2}=app.SliderD_23;
app.handles.Detectors{23,3}=app.EditFieldD_23;
app.handles.Detectors{23,4}=app.LampD_23;
 
app.handles.Detectors{24,1}=app.PanelD_24;
app.handles.Detectors{24,2}=app.SliderD_24;
app.handles.Detectors{24,3}=app.EditFieldD_24;
app.handles.Detectors{24,4}=app.LampD_24;
 
app.handles.Detectors{25,1}=app.PanelD_25;
app.handles.Detectors{25,2}=app.SliderD_25;
app.handles.Detectors{25,3}=app.EditFieldD_25;
app.handles.Detectors{25,4}=app.LampD_25;
 
app.handles.Detectors{26,1}=app.PanelD_26;
app.handles.Detectors{26,2}=app.SliderD_26;
app.handles.Detectors{26,3}=app.EditFieldD_26;
app.handles.Detectors{26,4}=app.LampD_26;
 
app.handles.Detectors{27,1}=app.PanelD_27;
app.handles.Detectors{27,2}=app.SliderD_27;
app.handles.Detectors{27,3}=app.EditFieldD_27;
app.handles.Detectors{27,4}=app.LampD_27;
 
app.handles.Detectors{28,1}=app.PanelD_28;
app.handles.Detectors{28,2}=app.SliderD_28;
app.handles.Detectors{28,3}=app.EditFieldD_28;
app.handles.Detectors{28,4}=app.LampD_28;
 
app.handles.Detectors{29,1}=app.PanelD_29;
app.handles.Detectors{29,2}=app.SliderD_29;
app.handles.Detectors{29,3}=app.EditFieldD_29;
app.handles.Detectors{29,4}=app.LampD_29;
 
app.handles.Detectors{30,1}=app.PanelD_30;
app.handles.Detectors{30,2}=app.SliderD_30;
app.handles.Detectors{30,3}=app.EditFieldD_30;
app.handles.Detectors{30,4}=app.LampD_30;
 
app.handles.Detectors{31,1}=app.PanelD_31;
app.handles.Detectors{31,2}=app.SliderD_31;
app.handles.Detectors{31,3}=app.EditFieldD_31;
app.handles.Detectors{31,4}=app.LampD_31;
 
app.handles.Detectors{32,1}=app.PanelD_32;
app.handles.Detectors{32,2}=app.SliderD_32;
app.handles.Detectors{32,3}=app.EditFieldD_32;
app.handles.Detectors{32,4}=app.LampD_32;

for i=1:size(app.handles.Detectors,1)
    app.handles.Detectors{i,1}.Title=num2str(i);
    app.handles.Detectors{i,2}.Limits=[1 255];
    app.handles.Detectors{i,3}.Limits=[1 255];
    app.handles.Detectors{i,3}.Value=1;
    app.handles.Detectors{i,2}.Value=1;
    app.handles.Detectors{i,4}.Color=[.6 .6 .6];
    
    app.handles.Detectors{i,2}.ValueChangedFcn=@UpdateDetectorSlider;
    app.handles.Detectors{i,3}.ValueChangedFcn=@UpdateDetectorSpinner;
    app.handles.Detectors{i,2}.UserData=i;
    app.handles.Detectors{i,3}.UserData=i;
    
end




% TO DO-  set default sample rate




return