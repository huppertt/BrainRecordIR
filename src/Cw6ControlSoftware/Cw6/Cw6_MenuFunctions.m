function Cw6_MenuFunctions(varargin)

if ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK
    
        try
		    [varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
	    catch
            disp(lasterr); 
        end

end

return



% --------------------------------------------------------------------
function NewSubject_Callback(hObject, eventdata, handles)
h=RegisterSubject;
moniterpos=get(0,'MonitorPositions');
set(h,'units','pixels');
set(h,'position',get(h,'position')+[moniterpos(2,1) 0 0 0]);



% --------------------------------------------------------------------
function SystemInfo_Menu_Callback(hObject, eventdata, handles)
msg=sprintf('%s\n%s\n',...
    'CW6 Data Aquistion Software Version 0.1',...
    '<DETAILS OF SYSTEM>');
    h=msgbox(msg);
    moniterpos=get(0,'MonitorPositions');
    set(h,'units','pixels');
    set(h,'position',get(h,'position')+[moniterpos(2,1) 0 0 0]);

    uiwait(h);
return

% --------------------------------------------------------------------
function Help_Menu_Callback(hObject, eventdata, handles)
%Launch HELP PDF support
PDFfile=which('HELP.pdf');  
open(PDFfile);

% --------------------------------------------------------------------
function About_Menu_Callback(hObject, eventdata, handles)
%The about message.  
msg=sprintf('%s\n%s\n%s\n',...
    'CW6 Data Aquistion Software Version 0.1',...
    'Written by T. Huppert',...
    'University of Pittsburgh');
    %Try to place the bitmap icon there too
%     BMPfile=which('HomerIcon.bmp');
%     Icon=imread(BMPfile,'BMP');
%     h=msgbox(msg,'','custom',Icon,hot(64));

    h=msgbox(msg);
    
     moniterpos=get(0,'MonitorPositions');
    set(h,'units','pixels');
    set(h,'position',get(h,'position')+[moniterpos(2,1) 0 0 0]);

    
    uiwait(h);
return


% --------------------------------------------------------------------
function RTProcessing_Callback(hObject, eventdata, handles)
% hObject    handle to RTProcessing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=RealTimeFilterSetupMenu;
 moniterpos=get(0,'MonitorPositions');
    set(h,'units','pixels');
    set(h,'position',get(h,'position')+[moniterpos(2,1) 0 0 0]);
