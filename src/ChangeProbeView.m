function ChangeProbeView(handles,hObject)

global BrainRecordIRApp;

type=BrainRecordIRApp.DrawMode4Probe.Value;
for i=1:length(BrainRecordIRApp.Subject.data)
    switch(type)
        case('2D View')
            BrainRecordIRApp.Subject.data(i).probe.defaultdrawfcn='2D';
        case('10-20 View')
            BrainRecordIRApp.Subject.data(i).probe.defaultdrawfcn='10-20 zoom';
        case('3D View')
            BrainRecordIRApp.Subject.data(i).probe.defaultdrawfcn='3D mesh (frontal) zoom';
    end
end


BrainRecordIRApp.Drawing.SDGhandles=[];
Update_BrainRecorderAll;
return
