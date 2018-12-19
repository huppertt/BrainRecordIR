function SystemMessage(msg)
% This function will write a message/string to the System tab of the
% interface.  This is called from various parts of the code to provide
% DEBUG information on the system

global BrainRecordIRApp;

BrainRecordIRApp.SystemMessageTextArea.Value{end+1}=msg;