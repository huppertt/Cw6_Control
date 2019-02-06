function GSS_model=init_gssm
%This function generates the gssm_GLM structure

try
handles=guihandles(findobj('tag','cw6figure'));
SubjInfo=get(handles.RegistrationInfo,'UserData');
SD=SubjInfo.Probe;
    
system=get(handles.AquistionButtons,'Userdata');
fs=getdatarate(system.MainDevice);
catch
    SD=evalin('base','SD;');
    fs=evalin('base','1/mean(diff(Cw6_data.data.raw_t));');
end
nMeas=size(SD.MeasList,1);

G=speye(nMeas);
L=speye(nMeas);
GSS_model.model= gssm_fNIR2('init',L,[1 1 1]',G,fs);


%Estimation
Arg.type = 'state';                                 % inference type (state estimation)
Arg.tag = 'State estimation for GLM system.';       % arbitrary ID tag
Arg.model = GSS_model.model;                                % GSSM data structure of external system
GSS_model.InfDS = geninfds(Arg);                               % Create inference data structure and
[GSS_model.pNoise, GSS_model.oNoise, GSS_model.InfDS] = gensysnoiseds(GSS_model.InfDS, 'kf');       % generate process and observation noise sources
