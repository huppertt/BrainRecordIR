function LoadPrevious

global BrainRecordIRApp;


[filename, pathname] = uigetfile({'*.nirs';'*.nir5'}, 'Pick a NIRS data file','MultiSelect', 'on');
if isequal(filename,0) || isequal(pathname,0)
    return
end

if(~iscellstr(filename))
    filename=cellstr(filename);
end

for i=1:length(filename)
    if(~isempty(strfind(filename{i},'.nirs')))
        raw=nirs.io.loadDotNirs(fullfile(pathname,filename{i}));
    else
        raw=nirs.io.loadNIR5(fullfile(pathname,filename{i}));
    end
    if(isa(raw.probe,'nirs.core.Probe1020'));
        raw.probe.defaultdrawfcn='2D';
        raw.probe=raw.probe.SetFiducialsVisibility(false);
        m=raw.probe.getmesh;
        m(1:end-1)=[];
         raw.probe=raw.probe.register_mesh2probe(m,true);
    end
    a=uitreenode(BrainRecordIRApp.LoadedFilesNode,'Text',filename{i},'NodeData',[],'Userdata',raw);
    set(BrainRecordIRApp.Tree,'SelectionChangedFcn',@SelectSaveFile);
    BrainRecordIRApp.Tree.SelectedNodes=a;
 
end
    
BrainRecordIRApp.Subject.data=raw;

% turn on the controls on the APP.
ControlEnable(true);
   
return
