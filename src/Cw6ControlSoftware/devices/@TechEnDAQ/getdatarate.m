function rate=getdatarate(obj)

try
    rate=getdatarate(obj.system);
catch
    rate=[];
    warning('get data rate failed');
end


return