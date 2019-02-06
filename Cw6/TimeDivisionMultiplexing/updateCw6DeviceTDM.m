function updateCw6DeviceTDM

global NUM_SRC;
global NUM_DET;

Cw6handles=guihandles(findobj('tag','cw6figure'));
SubjInfo=get(Cw6handles.RegistrationInfo,'UserData');
system=get(Cw6handles.AquistionButtons,'Userdata');
Javahandles=get(findobj('tag','DetTabContainer'),'UserData');
     
if(~isfield(system,'AQSettings'))
   system.AQSettings.Lasers=zeros(NUM_SRC,1);
elseif(~isfield(system.AQSettings,'Lasers'))
   system.AQSettings.Lasers=zeros(NUM_SRC,1);
end
    
if(~isfield(system,'AQSettings'))
    system.AQSettings.Gains=zeros(NUM_DET,1);
elseif(~isfield(system.AQSettings,'Gains'))
    system.AQSettings.Gains=zeros(NUM_DET,1);
end

if(~isfield(system,'TDMSettings') || ~isfield(system.TDMSettings,'LasersOn'))
    return;
end
if(length(unique(SubjInfo.Probe.MeasList(:,5)))==1)
    return;
end

state=system.TDMSettings.StateSelected;
system.AQSettings.Lasers=system.TDMSettings.LasersOn(:,state);
system.AQSettings.Gains=system.TDMSettings.DetGains(:,state);

set(Cw6handles.AquistionButtons,'Userdata',system);

%Set Gains
for DetIdx=1:NUM_DET
    Tab=1+floor((DetIdx-1)/8);
    Det=mod(DetIdx,8);
    if(Det==0); Det=8; end;
    value=system.AQSettings.Gains(DetIdx);
    set(Javahandles.spinner(Tab,Det),'Value',value);     
    set(Javahandles.slider(Tab,Det),'Value',value);
    
    if(~isempty(find(SubjInfo.Probe.MeasList(:,5)==state & ...
            SubjInfo.Probe.MeasList(:,2)==DetIdx)))
        set(Javahandles.slider(Tab,Det),'enabled',1);
        set(Javahandles.spinner(Tab,Det),'enabled',1);
    else
        set(Javahandles.slider(Tab,Det),'enabled',0);
        set(Javahandles.spinner(Tab,Det),'enabled',0);
    end
end
Cw6_BackEnd('SetGain');

Javahandles=get(findobj('tag','SrcTabContainer'),'UserData');
%Set Lasers
for laserIdx=1:NUM_SRC
    set(Javahandles.Lasers(laserIdx),'value',system.AQSettings.Lasers(laserIdx));
    setlaser(system.MainDevice,laserIdx,system.AQSettings.Lasers(laserIdx));

    [SrcIdx,lambdx]=find(SubjInfo.Probe.LaserPos==laserIdx);
    if(~isempty(SrcIdx))
    if(~isempty(find(SubjInfo.Probe.MeasList(:,5)==state & ...
            SubjInfo.Probe.MeasList(:,1)==SrcIdx)))
        set(Javahandles.Lasers(laserIdx),'enable','on');
    else
        set(Javahandles.Lasers(laserIdx),'enable','off');
    end
    end
end

return