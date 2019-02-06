function SetTDM_toDevice(useTDM)

handles=guihandles(findobj('tag','cw6figure'));

system=get(handles.AquistionButtons,'Userdata');

if(~isfield(system,'TDMSettings') ||~isfield(system.TDMSettings,'LasersOn'))
    SetUseTDML(system.MainDevice,false);
    return;
end

if(~isfield(system.TDMSettings,'NumStates'))
    SetUseTDML(system.MainDevice,false);
    return
end

numStates=system.TDMSettings.NumStates;



for state=numStates:-1:1
    dwelltime=system.TDMSettings.DwellTimes(state);
    gains=system.TDMSettings.DetGains(:,state);
    lasers=system.TDMSettings.LasersOn(:,state);
    SetState(system.MainDevice,state,dwelltime,gains,lasers);
end

state=system.TDMSettings.StateSelected;
dwelltime=system.TDMSettings.DwellTimes(state);
gains=system.TDMSettings.DetGains(:,state);
lasers=system.TDMSettings.LasersOn(:,state);
SetState(system.MainDevice,state,dwelltime,gains,lasers);

    
SetUseTDML(system.MainDevice,useTDM);

return