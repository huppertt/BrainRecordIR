function GUIChangeDetector_callback(Tab,Det)


MAXGAIN=255;
MINGAIN=0;

value=get(gcbo,'value');

if(value>MAXGAIN)
    value=MAXGAIN;
end
if(value<MINGAIN)
    value=MINGAIN;
end

Javahandles=get(findobj('tag','DetTabContainer'),'UserData');
 
if(~isstruct(Javahandles))
    %Things not loaded yet
    return
end

if(get(Javahandles.spinner(Tab,Det),'Value')~=value)
    set(Javahandles.spinner(Tab,Det),'Value',value);     
end
if(get(Javahandles.slider(Tab,Det),'Value')~=value)
    set(Javahandles.slider(Tab,Det),'Value',value);
end    
Cw6_BackEnd('SetGain');


return