function GUIChangeLaserInten_callback(varargin);

try
global NUM_SRC;
global MAX_LASER_INTEN;

handles=guihandles(findobj('tag','cw6figure'));
system=get(handles.AquistionButtons,'Userdata');

Javahandles=get(findobj('tag','SrcTabContainer'),'UserData');
    
for idx=1:length(Javahandles.spinner)
    %Inten(idx)=get(Javahandles.spinner(idx),'value');
    Inten(idx)=get(Javahandles.spinner(idx),'value');
    Inten(idx)=max(Inten(idx),0);
    if(Inten(idx)> MAX_LASER_INTEN)
        Inten(idx)=MAX_LASER_INTEN;
        set(Javahandles.spinner(idx),'value',Inten(idx));
    end
    
end
setlaserpower(system.MainDevice,Inten);
end


return