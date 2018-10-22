function EditWindowData(handles,hObject)


xlim=get(handles.TabViewsPanel(1),'XLim');
    
if(get(handles.windowdatacheck,'value'))
    v=get(handles.windowdataedit,'value');
    xlim(1)=max(0,xlim(2)-v);    
else
    xlim(1)=0;
    
end
set(handles.TabViewsPanel(1),'XLim',xlim);

return