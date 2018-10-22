function loadCw6ConfigFile(handles)

global PROBE_DIR;
global DATA_DIR;
global SYSTEM_TYPE;
global NUM_SRC;
global NUM_DET;
global NUM_LAMBDA;
global LAMBDA;

cfgfile=which('cw6.cfg');
if(isempty(cfgfile))
    %load defaults
    PROBE_DIR='C:\Cw6';
    DATA_DIR='C:\Cw6\Data';
else
    fid=fopen(cfgfile,'r');
    while(1)
        line=fgetl(fid);
        if(line==-1); break; end;
        if(isempty(strfind(line,'#')))
            try; eval(line); end;
        end
    end
    fclose(fid);
end

s=whos;
if(any((vertcat(s([1:end]).bytes)==0)))
    warning('Missing Config parameters');
end
return