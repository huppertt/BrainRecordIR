function DataToMLMap=SendML2Cw6(ml_probe,SD,ml_Device);



figurehandle=findobj('tag','cw6figure');
AquistionButtons=findobj('tag','AquistionButtons');
system=get(AquistionButtons,'Userdata');

states=zeros(size(ml_Device,1),1);

DataToMLMap=zeros(size(ml_probe,1),1);

mlMap=SD.mlMap;

for idx=1:length(mlMap)
    states(mlMap(idx))=1;
end

cnt=0;
for idx=1:length(states);
    setML(system.MainDevice,idx,states(idx));
end

lst=find(states==1);

global Cw6device;
frqmap=Cw6device.SystemInfo.frqMap;

ml=[]; cnt=0;
for Didx=1:32
    for Sidx=1:length(frqmap)
        Lidx=find(frqmap==Sidx);
        if(~isempty(Lidx))
            thispoint=find(ml_Device(lst,2)==Didx & ml_Device(lst,1)==Lidx);
            if(~isempty(thispoint))
                cnt=cnt+1;
                ml=[ml; Lidx Didx Sidx];
            end
        end
    end
    lst2=find(ml(:,2)==Didx);
    ml(lst2,:)=sortrows(ml(lst2,:),3);

end


for idx=1:size(ml_probe,1); 
    SrcIdx=ml_probe(idx,1);
    DetIdx=ml_probe(idx,2);
    LambdaIdx=ml_probe(idx,4);
    LaserIdx=SD.LaserPos(SrcIdx,LambdaIdx);
   % LaserIdx=find(frqmap==LaserIdx)
    DataToMLMap(idx)=find(ml(:,1)==LaserIdx & ml(:,2)==DetIdx);
end

return