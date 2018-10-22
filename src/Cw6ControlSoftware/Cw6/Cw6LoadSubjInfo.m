function Cw6LoadSubjInfo(SubjInfo)
%This function loads the registration info from the sub-GUI

global PROBE_DIR;
global DATA_DIR;
global SYSTEM_TYPE;
global NUM_SRC;
global NUM_DET;
global NUM_LAMBDA;
global LAMBDA;

handles=guihandles(findobj('tag','cw6figure'));

%Create a Data folder if not exist:
SubjInfo.DataDir(strfind(SubjInfo.DataDir,' '))='_';
SubjInfo.DataDir(2+strfind(SubjInfo.DataDir(3:end),':'))='_';
mkdir(SubjInfo.DataDir);
cd(SubjInfo.DataDir);


set(handles.SubjID,'string',SubjInfo.SubjID);
set(handles.SubjID,'enable','on');

SubjInfo.Scan=1;
SubjInfo.CurrentFileName=[SubjInfo.SubjID '-' SubjInfo.Study '-scan' num2str(SubjInfo.Scan) '-<DateTime>'];
set((handles.CurDataFileName),'string',SubjInfo.CurrentFileName);
set((handles.CurDataFileName),'enable','on');
set(handles.StartAQ,'enable','on');


SubjInfo.Probe.Lambda=LAMBDA;
SubjInfo.Probe.Colors=jet(length(find(SubjInfo.Probe.MeasList(:,4)==1)));
SubjInfo.Probe.Colors=[SubjInfo.Probe.Colors(1:2:end,:); SubjInfo.Probe.Colors(2:2:end,:)];
SubjInfo.SDGdisplay.selectedLambda=1;
SubjInfo.SDGdisplay.MLAct=ones(length(SubjInfo.Probe.MeasList),1);
lowSrc=min(SubjInfo.Probe.MeasList(:,1));
SubjInfo.SDGdisplay.PlotLst=find(SubjInfo.Probe.MeasList(:,4)==1 & SubjInfo.Probe.MeasList(:,1)==lowSrc);


set(handles.RegistrationInfo,'UserData',SubjInfo);


h=findobj(handles.cw6figure);
for idx=1:length(h); 
    try; set(h(idx),'enable','on'); end;
end;

global PROBE_DIR;
if(exist([PROBE_DIR filesep 'RealTimeModules'])==0)
    set(handles.RTProcessing,'enable','off');
end


PlotSDG(handles);

return