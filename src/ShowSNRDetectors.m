function ShowSNRDetectors

global BrainRecordIRApp;
data=BrainRecordIRApp.Subject.data(1);   
nirs.reports.channelSummaryPlot(data);

return