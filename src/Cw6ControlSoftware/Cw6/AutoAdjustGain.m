function AutoAdjustGain(varargin)

h=waitbar(0,'Adjusting AGC');

handles=guihandles(findobj('tag','cw6figure'));
system=get(handles.AquistionButtons,'Userdata');
Javahandles=get(findobj('tag','DetTabContainer'),'UserData');

[numTabs,numDet]=size(Javahandles.spinner);

SubjInfo=get(handles.RegistrationInfo,'UserData');
SD=SubjInfo.Probe;

adjusting=true;
maxTime=20;
tic;
while(adjusting)
    
    Te=toc;
    h=waitbar(Te/maxTime,h);
    if(Te>maxTime)
        break;
    end
gainchanges=getgainstep(Javahandles.spinner,system,SD);    
istop=zeros(SD.NumDet,1);
if(sum(gainchanges)==0)
    adjusting=false;
    break;
end
    
for Tab=1:numTabs
    for Det=1:numDet
        DetIdx=Det+numDet*(Tab-1);
        if(~isempty(find(SD.MeasList(:,2)==DetIdx)))
            val=get(Javahandles.spinner(Tab,Det),'Value');
            set(Javahandles.spinner(Tab,Det),'Value',val+gainchanges(DetIdx));
            if(val>=255)
                istop(DetIdx)=1;
            end
        else
            set(Javahandles.spinner(Tab,Det),'Value',0);
        end
    end
end

if(all(istop==1))
    break;
end

end

try
    close(h);
end

return

function gainchanges=getgainstep(spinners,system,SD)

persistent SNR;
persistent LASETGAINCHANGE;

gainchanges=zeros(SD.NumDet,1);

if(isempty(SNR))
    SNR=zeros(SD.NumDet,1);
    LASETGAINCHANGE=100*ones(SD.NumDet,1);
end

start(system.MainDevice);
pause(1);
stop(system.MainDevice);
[d,t]=getsamples(system.MainDevice,samplesavaliable(system.MainDevice));

%SNR_raw=mean(d(1:end-5,:),2)./std(d(1:end-5,:),[],2);
[fa,fb]=butter(4,[.1 1.4]*2/10);
[fa2,fb2]=butter(4,[3]*2/10,'high');

d_phys=filtfilt(fa,fb,d(1:end-5,:));
d_noise=filtfilt(fa2,fb2,d(1:end-5,:));

SNR_raw=var(d_phys,[],2)./var(d_noise,[],2);


SNR_det=zeros(SD.NumDet,1);
for dIdx=1:SD.NumDet
    lst=find(SD.MeasList(:,2)==dIdx);
    SNR_det(dIdx)=mean(SNR_raw(lst));
end

dSNR=SNR_det-SNR;

LASETGAINCHANGE=abs(LASETGAINCHANGE);

lstgood=find(dSNR>0);
gainchanges(lstgood)=LASETGAINCHANGE(lstgood);
lstbad=find(dSNR<0);
gainchanges(lstbad)=-.5*LASETGAINCHANGE(lstbad);

gainchanges=round(gainchanges);

LASETGAINCHANGE=gainchanges;
SNR=SNR_det;

return