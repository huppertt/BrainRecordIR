function ShowSNRDetectors(handles,hObject)

if(isfield(handles,'Subject') && isfield(handles.Subject,'data') && ~isempty(handles.Subject.data.data))
    data=handles.Subject.data;
    
    nirs.reports.channelSummaryPlot(data);
end

return