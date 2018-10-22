function writemsg(obj,msg)
handle=findobj('tag','simulatorfigure');
actx=get(handle,'UserData');
str=sprintf('%s\n%s',get(actx,'Text'),msg);
set(actx,'Text',str);
return