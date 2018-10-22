function RegisterSubject(handles,hObject)
% This function launches the GUI to register a new subject for aquistion

thishandles.figure=uifigure('tag','RegisterSubject','Name','Register Subject');
set(thishandles.figure,'Position',[150 300 600 600]);

thishandles.SDGwindow=uiaxes('parent',thishandles.figure);
set(thishandles.SDGwindow,'Box','on','Xtick',[],'ytick',[]);
set(thishandles.SDGwindow,'Position',[300 300 280 280]);

thishandles.comments=uitextarea('parent',thishandles.figure);
set(thishandles.comments,'Position',[305 60 270 250]);
h=uilabel('parent',thishandles.figure);
set(h,'Text','Comments','FontWeight','BOLD');
set(h,'Position',[305 310 270 20]);

thishandles.selectInvestigator=uidropdown('parent',thishandles.figure);
set(thishandles.selectInvestigator,'Position',[30 500 250 30])

folder=dir(handles.system.Folders.DefaultData);
n={};
for i=1:length(folder)
    if(folder(i).isdir & isempty(strfind(folder(i).name,'.')))
        n{end+1}=folder(i).name;
    end
end
set(thishandles.selectInvestigator,'Items',n);
h=uilabel('parent',thishandles.figure);
set(h,'Text','Investigators','FontWeight','BOLD');
set(h,'Position',[30 530 250 20]);


thishandles.selectStudy=uidropdown('parent',thishandles.figure);
set(thishandles.selectStudy,'Position',[30 430 250 30])

folder=dir(fullfile(handles.system.Folders.DefaultData,n{1}));
n2={};
for i=1:length(folder)
    if(folder(i).isdir & isempty(strfind(folder(i).name,'.')))
        n2{end+1}=folder(i).name;
    end
end
set(thishandles.selectStudy,'Items',n2);
h=uilabel('parent',thishandles.figure);
set(h,'Text','Studies','FontWeight','BOLD');
set(h,'Position',[30 460 250 20]);

thishandles.selectSubject=uidropdown('parent',thishandles.figure);
set(thishandles.selectSubject,'Position',[30 360 250 30])

folder=dir(fullfile(handles.system.Folders.DefaultData,n{1},n2{1}));
n3={'New Subject'};
for i=1:length(folder)
    if(folder(i).isdir & isempty(strfind(folder(i).name,'.')))
        n3{end+1}=folder(i).name;
    end
end
set(thishandles.selectSubject,'Items',n3);
set(thishandles.selectSubject,'Editable','on')
h=uilabel('parent',thishandles.figure);
set(h,'Text','Subject ID','FontWeight','BOLD');
set(h,'Position',[30 390 250 20]);

thishandles.probe=getprobes(fullfile(handles.system.Folders.DefaultData,n{1},n2{1}));
thishandles.probe.draw([],[],thishandles.SDGwindow);

% Add the demographics table
thishandles.demotable=uitable('parent',thishandles.figure);
set(thishandles.demotable,'Position',[30 10 250 300]);
colnames = {'Field', 'Value'};
set(thishandles.demotable,'ColumnName',colnames);  

set(thishandles.demotable,'ColumnFormat',{'char','char'});
set(thishandles.demotable,'ColumnEditable',[true true]);
Data=cell(15,2);
Data{1,1}='Age';  Data{1,2}='';
Data{2,1}='Gender'; Data{2,2}='';
Data{3,1}='Group';  Data{3,2}='';
Data{4,1}='SubGroup'; Data{4,2}='';
Data{5,1}='Circumference'; Data{5,2}='';
Data{6,1}='Nasion-Cz-Inion'; Data{6,2}='';
Data{7,1}='LPA-Cz=RPA'; Data{7,2}='';
Data{8,1}='Technician'; Data{8,2}='';
Data{9,1}=''; Data{9,2}='';
Data{10,1}=''; Data{10,2}='';
Data{11,1}=''; Data{11,2}='';
Data{12,1}=''; Data{12,2}='';
Data{13,1}=''; Data{13,2}='';
Data{14,1}=''; Data{14,2}='';
Data{15,1}=''; Data{15,2}='';
set(thishandles.demotable,'Data',Data);


h=uilabel('parent',thishandles.figure);
set(h,'Text','Demographics','FontWeight','BOLD');
set(h,'Position',[30 310 250 20]);

thishandles.Accept=uibutton('parent',thishandles.figure);
set(thishandles.Accept,'Text','Accept','FontWeight','BOLD')
set(thishandles.Accept,'Position',[455 10 120 40])


thishandles.Cancel=uibutton('parent',thishandles.figure);
set(thishandles.Cancel,'Text','Cancel','FontWeight','BOLD')
set(thishandles.Cancel,'Position',[320 10 120 40])

set(thishandles.Accept,'ButtonPushedFcn',@Accept);
set(thishandles.Cancel,'ButtonPushedFcn',@Cancel);
set(thishandles.selectInvestigator,'ValueChangedFcn',@SelectInvest);
set(thishandles.selectStudy,'ValueChangedFcn',@SelectStudy);
set(thishandles.selectSubject,'ValueChangedFcn',@SelectSubjID);

set(thishandles.figure,'Userdata',{handles thishandles});


return


function probe = getprobes(folder)

% for now
raw=nirs.testing.simData;
probe=raw.probe;

return

function Accept(varargin)
handles=get(get(varargin{1},'Parent'),'Userdata');
thishandles=handles{2};
handles=handles{1};

Inv=get(thishandles.selectInvestigator,'Value');
Study=get(thishandles.selectStudy,'Value');
SubjID=get(thishandles.selectSubject,'Value');

data=nirs.core.Data();
data.probe=thishandles.probe;

demoData=get(thishandles.demotable,'Data');
data.demographics('investigator')=Inv;
data.demographics('study')=Study;
data.demographics('subject')=SubjID;

for i=1:size(demoData,1)
    if(~isempty(demoData{i,1}) & ~isempty(demoData{i,2}))
        data.demographics(demoData{i,1})=demoData{i,2};
    end
end

handles.Subject.data=data;



set(handles.numstimlabel,'Text','#events=0');

types={};
utypes=unique(handles.Subject.data.probe.link.type);
for i=1:length(utypes)
    types{end+1}=['Raw: ' num2str(utypes(i)) 'nm'];
end
set(handles.SwitchType,'Items',types);


set(handles.BrainRecordIR,'Userdata',handles);

Update_BrainRecorderAll(handles);

delete(thishandles.figure);


return

function Cancel(varargin)

handles=get(get(varargin{1},'Parent'),'Userdata');
thishandles=handles{2};
handles=handles{1};
delete(thishandles.figure);
return

function SelectInvest(varargin)

handles=get(get(varargin{1},'Parent'),'Userdata');
thishandles=handles{2};
handles=handles{1};

Inv=get(thishandles.selectInvestigator,'Value');
folder=dir(fullfile(handles.system.Folders.DefaultData,Inv));
n2={};
for i=1:length(folder)
    if(folder(i).isdir & isempty(strfind(folder(i).name,'.')))
        n2{end+1}=folder(i).name;
    end
end
set(thishandles.selectStudy,'Items',n2);
folder=dir(fullfile(handles.system.Folders.DefaultData,Inv,n2{1}));
n3={'New Subject'};
for i=1:length(folder)
    if(folder(i).isdir & isempty(strfind(folder(i).name,'.')))
        n3{end+1}=folder(i).name;
    end
end
set(thishandles.selectSubject,'Items',n3);

thishandles.probe=getprobes(fullfile(handles.system.Folders.DefaultData,Inv,n2{1}));
cla(thishandles.SDGwindow);
thishandles.probe.draw([],[],thishandles.SDGwindow);

return

function SelectStudy(varargin)
handles=get(get(varargin{1},'Parent'),'Userdata');
thishandles=handles{2};
handles=handles{1};

Inv=get(thishandles.selectInvestigator,'Value');
Study=get(thishandles.selectStudy,'Value');

folder=dir(fullfile(handles.system.Folders.DefaultData,Inv,Study));
n3={'New Subject'};
for i=1:length(folder)
    if(folder(i).isdir & isempty(strfind(folder(i).name,'.')))
        n3{end+1}=folder(i).name;
    end
end
set(thishandles.selectSubject,'Items',n3);

thishandles.probe=getprobes(fullfile(handles.system.Folders.DefaultData,Inv,n2{1}));
cla(thishandles.SDGwindow);
thishandles.probe.draw([],[],thishandles.SDGwindow);

return

function SelectSubjID(varargin)

return
