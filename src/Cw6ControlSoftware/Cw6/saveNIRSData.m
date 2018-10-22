function saveNIRSData(Cw6_data,SubjInfo)
%This function creates a NIRS probe file for HOMER

d=Cw6_data.data.raw;
t=Cw6_data.data.raw_t;
aux=Cw6_data.data.aux;
SD=SubjInfo.Probe;
ml=SD.MeasList(:,1:4);
if(isfield(Cw6_data.data,'stim'))
    s=zeros(size(t));
    for idx=1:length(Cw6_data.data.stim)
        [foo,id]=min(abs(t-Cw6_data.data.stim(idx)));
        s(id)=1;
    end 
else
    s=zeros(size(t));
end
filename=[SubjInfo.SubjID '-' SubjInfo.Study '-scan' num2str(SubjInfo.Scan) '-' datestr(now,'yyyymmddTHHMMSS-CW6')];
save([filename '.nirs'],'d','ml','s','t','aux','SD','-MAT');
save([filename '.mat'],'Cw6_data','SubjInfo');


return