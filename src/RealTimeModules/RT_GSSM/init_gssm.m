function GSS_model=init_gssm
%This function generates the gssm_GLM structure

if(0)
handles=guihandles(findobj('tag','cw6figure'));
SubjInfo=get(handles.RegistrationInfo,'UserData');
SD=SubjInfo.Probe;

system=get(handles.AquistionButtons,'Userdata');
fs=getdatarate(system.MainDevice);

nMeas=size(SD.MeasList,1);
else
    nMeas=28;
    fs=10;
end
G=speye(nMeas);
L=speye(nMeas);
GSS_model.model=gssm_fNIR('init',L,1,G,fs);


%Estimation
Arg.type = 'state';                                 % inference type (state estimation)
Arg.tag = 'State estimation for GLM system.';       % arbitrary ID tag
Arg.model = GSS_model.model;                                % GSSM data structure of external system
GSS_model.InfDS = geninfds(Arg);                               % Create inference data structure and
[GSS_model.pNoise, GSS_model.oNoise, GSS_model.InfDS] = gensysnoiseds(GSS_model.InfDS, 'kf');       % generate process and observation noise sources
