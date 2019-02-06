function SetAllLasers(varargin)

global NUM_SRC;

hObject=findobj('tag','ChangeAllLasers');
handles=guihandles(findobj('tag','cw6figure'));

if(isfield(gcbo,'value'))
    value=get(gcbo,'value');
else
    ChangeAllLasers=findobj('tag','ChangeAllLasers');
    value=get(ChangeAllLasers(1),'value');
end


ChangeAllLasers=findobj('tag','ChangeAllLasers');
set(ChangeAllLasers,'value',value);

statet=get(ChangeAllLasers,'UserData');
state=statet{1};

if(state==0)
    %turn all on
    set(ChangeAllLasers,'string','All Lasers Off');
    set(ChangeAllLasers,'UserData',1);
else
    set(ChangeAllLasers,'string','All Lasers On');
    set(ChangeAllLasers,'UserData',0);
end

system=get(handles.AquistionButtons,'Userdata');

if(~isfield(system,'AQSettings'))
    system.AQSettings.Lasers=zeros(NUM_SRC,1);
elseif(~isfield(system.AQSettings,'Lasers'))
    system.AQSettings.Lasers=zeros(NUM_SRC,1);
end

system.AQSettings.Lasers(:)=get(ChangeAllLasers(1),'UserData');
set(handles.AquistionButtons,'Userdata',system);

Javahandles=get(findobj('tag','SrcTabContainer'),'UserData');
state=get(ChangeAllLasers(1),'UserData');

for idx=1:NUM_SRC
    las=findobj('tag',['Laser_' num2str(idx)]);
    if(strcmp(get(las,'enable'),'on') & strcmp(get(Javahandles.Lasers(idx),'enable'),'on'))
        if(state==1)
            set(las,'ForegroundColor',[1 0 0]);
        else
            set(las,'ForegroundColor',[0 0 0])
        end
        setlaser(system.MainDevice,idx,state);
    else
        setlaser(system.MainDevice,idx,0);
    end   
    
end

if(any(system.AQSettings.Lasers))
    set(findobj('tag','LaserLED'),'BackgroundColor','r');
else
     set(findobj('tag','LaserLED'),'BackgroundColor',[.6 .6 .6]);
end

return
