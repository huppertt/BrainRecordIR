function data=queryremotedir

data=[];

filename='remotedata';
persistent lastfile;

if(isempty(lastfile))
    lastfile='remotedata-0.dat';
end

lastF=dir(lastfile);

if(isempty(lastF))
    return
end
timestamp=datenum(lastF.date);
allfiles=dir([filename '*.dat']);

for idx=1:length(allfiles)
    timep(idx)=datenum(allfiles(idx).date);
end

lst=find(timep>timestamp);

if(isempty(lst))
    return
end
[foo,lstsort]=sort(timep(lst));

for idx=1:length(lstsort)
    fid=fopen(allfiles(lst(lstsort(idx))).name,'r');
    d=fread(fid,inf,'int16');
    fclose(fid);
    data=[data d];
end

lastfile=allfiles(lst(lstsort(end))).name;
    

