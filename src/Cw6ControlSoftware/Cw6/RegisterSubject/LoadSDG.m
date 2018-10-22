function SD = LoadSDG(fileName)

SD=[];
fid=fopen(fileName,'r');

if(fid==-1)
    return;
end

SD.Lambda=[830 690];

SD.Name=fileName;

%Load description into
SD.Description='';
frewind(fid);
while(1)
    line=fgetl(fid);
    if(~ischar(line))
        break;
    end
    if(~isempty(strfind(line,'!Description:')))
        SD.Description=sprintf('%s\n%s',SD.Description,line(2:end));
        while(1)
            line=fgetl(fid);
            if(~ischar(line) | ~isempty(strfind(line,'#')) | ~isempty(strfind(line,'!')))
                break;
            end
            SD.Description=sprintf('%s\n%s',SD.Description,line);
        end
        break;
    end
end

%Load geomerty
SD.NumSrc=[];
SD.NumDet=[];
SD.SrcPos=[];
SD.DetPos=[];

frewind(fid);
while(1)
    line=fgetl(fid);
    if(~ischar(line))
        break;
    end
    if(~isempty(strfind(line,'!Geometry:')))
        while(1)
            line=fgetl(fid);
            if(~ischar(line) | ~isempty(strfind(line,'#')) | ~isempty(strfind(line,'!')))
                break;
            end

            if(~isempty(strfind(line,'NumSrc')))
                eval(['SD.NumSrc = ' line(strfind(line,'=')+1:end) ';']);
                SD.SrcPos=zeros(SD.NumSrc,3);
            end
            if(~isempty(strfind(line,'NumDet')))
                eval(['SD.NumDet = ' line(strfind(line,'=')+1:end) ';']);
                SD.DetPos=zeros(SD.NumDet,3);
            end

            if(~isempty(strfind(line,'DetPos')))
                DetIdx=line(strfind(line,'DetPos')+length('DetPos'):strfind(line,'=')-1);
                eval(['SD.DetPos(' DetIdx ',:) = ' line(strfind(line,'=')+1:end) ';']);
            end
            if(~isempty(strfind(line,'SrcPos')))
                SrcIdx=line(strfind(line,'SrcPos')+length('SrcPos'):strfind(line,'=')-1);
                eval(['SD.SrcPos(' SrcIdx ',:) = ' line(strfind(line,'=')+1:end) ';']);
            end
        end
        break;
    end
end


%Measurement list
SD.MeasList=[];
frewind(fid);
StateIdx=1;
while(1)
    line=fgetl(fid);
    if(~ischar(line))
        break;
    end
    if(~isempty(strfind(line,'!Measurement')))
        while(1)
            line=fgetl(fid);

            if(~ischar(line) | ~isempty(strfind(line,'#')) | ~isempty(strfind(line,'!')))
                break;
            end

            if(~isempty(strfind(line,'NumStates')))
                eval(['NumStates = ' line(strfind(line,'=')+1:end) ';']);
            end
            if(~isempty(strfind(line,'State ')))
                eval(['StateIdx = ' line(strfind(line,'State')+length('State'):end) ';']);
            end
            if(~isempty(strfind(line,'measurement')))
                line=line(strfind(line,'measurement')+length('measurement'):end);
                line(strfind(line,'-'))=[];

                srcLst=strfind(lower(line),'s');
                numSrc=length(srcLst);

                detLst=strfind(lower(line),'d');
                numDet=length(detLst);
                srcLst=[srcLst detLst(1)];
                detLst=[detLst length(line)+1];
                for Sidx=1:numSrc
                    if(strcmp(lower(line(srcLst(Sidx)+1:srcLst(Sidx+1)-1)),'all'))
                        for SrcVal=1:SD.NumSrc
                            for Didx=1:numDet
                                if(strcmp(lower(line(detLst(Didx)+1:detLst(Didx+1)-1)),'all'))
                                    for DetVal=1:SD.NumDet
                                        SD.MeasList=[SD.MeasList; SrcVal DetVal 1 1 StateIdx];
                                    end
                                else
                                    DetVal=str2num(line(detLst(Didx)+1:detLst(Didx+1)-1));
                                    SD.MeasList=[SD.MeasList; SrcVal DetVal 1 1 StateIdx];
                                end
                            end
                        end
                    else
                        SrcVal=str2num(line(srcLst(Sidx)+1:srcLst(Sidx+1)-1));
                        for Didx=1:numDet
                            if(strcmp(lower(line(detLst(Didx)+1:detLst(Didx+1)-1)),'all'))
                                for DetVal=1:SD.NumDet
                                    SD.MeasList=[SD.MeasList; SrcVal DetVal 1 1 StateIdx];
                                end
                            else
                                DetVal=str2num(line(detLst(Didx)+1:detLst(Didx+1)-1));
                                SD.MeasList=[SD.MeasList; SrcVal DetVal 1 1 StateIdx];
                            end
                        end
                    end
                end

            end
        end
        break;
    end
end


%Finally Laser maps
SD.LaserPos=[];
frewind(fid);
while(1)
    line=fgetl(fid);
    if(~ischar(line))
        break;
    end
    if(~isempty(strfind(line,'!Laser')))
        while(1)
            line=fgetl(fid);
            if(~ischar(line) | ~isempty(strfind(line,'#')) | ~isempty(strfind(line,'!')))
                break;
            end
            line=line(strfind(lower(line),'laser')+length('laser'):end);

            SrcNum=(line(strfind(lower(line),'s')+1:strfind(lower(line),'-')-1));
            Laserlst=[strfind(lower(line),'l') length(line)+1];
            LasNum={};
            for idx=1:length(Laserlst)-1
                LasNum{idx}=(line(Laserlst(idx)+1:Laserlst(idx+1)-1));
            end
            for id=1:length(LasNum)
                eval(['SD.LaserPos(' SrcNum ',' num2str(id) ')=[' LasNum{id} '];']);
            end
        end
         break;
    end
   
end

SD.MeasList=unique(SD.MeasList,'rows');
NumLambda=length(SD.Lambda);
for idx=2:NumLambda
    mlTemp=SD.MeasList;
    mlTemp(:,4)=idx;
    SD.MeasList=[SD.MeasList; mlTemp];
end


frqmap=[1 9 2 10 3 11 4 12 5 13 6 14 7 15 8 16 17 25 18 26 19 27 20 28 21 29 22 30 23 31 24 32];
ml=[]; cnt=0;
for Didx=1:32
    for idx=1:length(frqmap)
        laserIdx=find(frqmap==idx);
        [srcidx,lambdaIdx]=find(SD.LaserPos==laserIdx);
        if(~isempty(srcidx))
            thispoint=find(SD.MeasList(:,2)==Didx & SD.MeasList(:,1)==srcidx &...
                SD.MeasList(:,4)==lambdaIdx);
            if(~isempty(thispoint))
                cnt=cnt+1;
                ml=[ml; SD.MeasList(thispoint,:)];
            end
        
        end
    end
        lst2=find(ml(:,2)==Didx);
        ml(lst2,:)=sortrows(ml(lst2,:),3);
end
SD.MeasList=ml;
return
