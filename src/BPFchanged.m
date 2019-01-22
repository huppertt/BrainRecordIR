function BPFchanged()


global BrainRecordIRApp;


fs=BrainRecordIRApp.Device.sample_rate;
BrainRecordIRApp.Realtime.BPF = BPF;
lpf=BrainRecordIRApp.LowPassEditField.Value;
hpf=BrainRecordIRApp.HighPassEditField.Value;
if(BrainRecordIRApp.CheckBox.Value & BrainRecordIRApp.CheckBox_2.Value)
    [fa,fb]=butter(4,[hpf lpf]*2/fs);  %bandpass
    BrainRecordIRApp.Realtime.BPF.initfilter(fa,fb);
elseif(~BrainRecordIRApp.CheckBox.Value & BrainRecordIRApp.CheckBox_2.Value)
    [fa,fb]=butter(4,[lpf]*2/fs); % low pass only
    BrainRecordIRApp.Realtime.BPF.initfilter(fa,fb);
elseif(BrainRecordIRApp.CheckBox.Value & ~BrainRecordIRApp.CheckBox_2.Value)
    [fa,fb]=butter(4,[hpf]*2/fs,'high'); % high pass only
    BrainRecordIRApp.Realtime.BPF.initfilter(fa,fb);
else
    BrainRecordIRApp.Realtime.BPF=[];
end

    