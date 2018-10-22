function varargout=BrainRecordIR(varargin)

global BrainRecordIRData;
try
    get(BrainRecordIRData,'WindowStyle');
catch
    BrainRecordIRData=[];
end

% make sure the matlab path is ok
folder=fileparts(which('BrainRecordIR.m'));
if(isempty(strfind(path,fullfile(folder,'src'))))
    disp('Adding BrainRecordIR files to path');
    path(path,genpath(folder));
end

if(nargin==0 & isempty(BrainRecordIRData))
    BrainRecordIRData=InitializeFigure();
    if(nargout==1)
        varargout{1}=BrainRecordIRData;
    end
    return;
end

if(nargin>0)
    if(strcmp(varargin{1},'Exit'))
        % This is a special case that we can't afford to get wrong
        handles=get(BrainRecordIRData,'UserData');
        delete(handles.BrainRecordIR);
        return
    end
    
    % Since I had trouble sending varargin through the uifigure callbacks,
    % parse the string to get any inputs.  This works because I never used
    % inputs more complicated then indexing parameters.
    n={};
    if(~isempty(strfind(varargin{1},'(')))
       str=varargin{1}(strfind(varargin{1},'(')+1:strfind(varargin{1},')')-1);
        varargin{1}=varargin{1}(1:strfind(varargin{1},'(')-1);
        while(~isempty(strfind(str,',')))
            [n{end+1},str]=strtok(str,',');
            if(~isempty(str2num(n{end})))
                n{end}=str2num(n{end});
            end
            str(1)=[];
        end
        n{end+1}=str;
        if(~isempty(str2num(n{end})))
                n{end}=str2num(n{end});
        end
            
    end
    
    if(length(n)>0)
        feval(varargin{1},get(BrainRecordIRData,'UserData'),gcbo,n{:});
    else
        feval(varargin{1},get(BrainRecordIRData,'UserData'),gcbo);
    end
end


if(nargout==1)
    varargout{1}=BrainRecordIRData;
end
return


