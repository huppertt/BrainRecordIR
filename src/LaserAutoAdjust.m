function LaserAutoAdjust(app)

global BrainRecordIRApp;

nSrc=size(BrainRecordIRApp.Subject.defaultdata.probe.srcPos,1);
nLam=length(BrainRecordIRApp.Subject.defaultdata.probe.types);

maxV = BrainRecordIRApp.handles.Lasers{1,2}.Limits(2);

cnt=1;
for i=1:nSrc
    for j=1:nLam;
        if(strcmp(BrainRecordIRApp.handles.Lasers{i,3+(j-1)*3}.Value,'On') )
             BrainRecordIRApp.handles.Lasers{i,2+(j-1)*3}.Value=maxV;
              BrainRecordIRApp.Device.setSrcPower(BrainRecordIRApp.handles.Lasers{i,3+(j-1)*3}.UserData,maxV);
        end
    end
end



flag = issaturated();
while(any(flag))
    cnt=1;
    nchange=true;
    for i=1:nSrc
        for j=1:nLam;
            val(cnt)=BrainRecordIRApp.handles.Lasers{i,2+(j-1)*3}.Value;
            if(strcmp(BrainRecordIRApp.handles.Lasers{i,3+(j-1)*3}.Value,'On') & flag(cnt))
                if(val(cnt)<=0)
                    BrainRecordIRApp.handles.Lasers{i,2+(j-1)*3}.Value=0;
                    BrainRecordIRApp.handles.Lasers{i,3+(j-1)*3}.Value='Off';
                    BrainRecordIRApp.handles.Lasers{i,4+(j-1)*3}.Color=[0 0 1];
                    BrainRecordIRApp.Device.setLaserState(BrainRecordIRApp.handles.Lasers{i,3+(j-1)*3}.UserData,false);
                else
                    nchange=false;
                end
                val(cnt)=val(cnt)-round(maxV/10);
                val(cnt)=max(val(cnt),0);
                BrainRecordIRApp.Device.setSrcPower(BrainRecordIRApp.handles.Lasers{i,3+(j-1)*3}.UserData,val(cnt));
                BrainRecordIRApp.handles.Lasers{i,2+(j-1)*3}.Value=val(cnt);
            end
            cnt=cnt+1;
        end
    end
    if( nchange)
        % all saturated at lowest gain
        break;
    end
    flag = issaturated();
    disp(flag)
end



return

function flag = issaturated()
global BrainRecordIRApp;
BrainRecordIRApp.Device.sendMLinfo(BrainRecordIRApp.Subject.data(1).probe);
BrainRecordIRApp.Device.Start; 
pause(.05); 
BrainRecordIRApp.Device.Stop;

[d,t]=BrainRecordIRApp.Device.get_samples(inf);

s=BrainRecordIRApp.Subject.data(1).probe.link;
s.detector=[];
[us,~,j]=unique(s);

satval=65020 ;
for i=1:height(us)
    flag(i)=any(median(d(:,j==i),1)>=satval);
end

