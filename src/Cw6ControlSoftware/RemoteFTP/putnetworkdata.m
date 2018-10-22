function putnetworkdata(data)
%This function puts data into a shared network directory to be retrieved by
%a remote machine

filename='remotedata';
persistent filenumber;

if(isempty(filenumber))
    filenumber=0;
else
    filenumber=filenumber+1;
end

fid=fopen([filename '-' num2str(filenumber) '.dat'],'w');
fwrite(fid,data,'int16');
fclose(fid);



return