function Javahandles=createAuxtab(parent)


%First make a panel to place the controls into
[Javahandles.Jpanel,Javahandles.JpanelCont]=javacomponent(javax.swing.JPanel);
set(Javahandles.JpanelCont,'Tag','AuxContainer');
set(Javahandles.JpanelCont,'parent',parent);
set(Javahandles.JpanelCont,'units','normalized');
set(Javahandles.JpanelCont,'position',[0 0 1 1]);

Javahandles.ChangeAllLasers=uicontrol('style','pushbutton','tag','ChangeAllLasers',...
    'units','normalized','parent',parent);
set(Javahandles.ChangeAllLasers,'string','All Lasers On','visible','on','position',[.02 .58 .15 .2]);
set(Javahandles.ChangeAllLasers,'Callback',@SetAllLasers);
set(Javahandles.ChangeAllLasers,'UserData',0);

Javahandles.LaserLED=uicontrol('style','edit','tag','LaserLED','parent',parent);
set(Javahandles.LaserLED,'units','normalized');
set(Javahandles.LaserLED,'enable','off');
set(Javahandles.LaserLED,'position',[.04 .6 .11 .05]);
set(Javahandles.LaserLED,'BackgroundColor',[.6 .6 .6]);


%make AGC button
Javahandles.AGC=uicontrol('style','pushbutton','tag','ShowAux','parent',parent);
set(Javahandles.AGC,'units','normalized','position',[.02 .08 .15 .2]);
set(Javahandles.AGC,'string','Show Auxillary','Callback','ShowAux');

hlink=linkprop(Javahandles.JpanelCont,'visible');

%Create controls for marking stimulus events
num_stim=5;
for idx=1:num_stim
   Javahandles.stim(idx,1)=uicontrol('Style','togglebutton','String','Mark','units','normalized','parent',parent,'callback',@markstim,'userdata',idx);
   Javahandles.stim(idx,2)=uicontrol('Style','edit','String',['Stim-' num2str(idx)],'units','normalized','parent',parent);
   Javahandles.stim(idx,3)=uicontrol('Style','checkbox','String','include','units','normalized','parent',parent);
   set(Javahandles.stim(idx,1),'Position',[.3 (num_stim-idx+1)/(num_stim+2) .1 1/(num_stim+2)]);
   set(Javahandles.stim(idx,2),'Position',[.42 (num_stim-idx+1)/(num_stim+2) .1 1/(num_stim+2)]);
   set(Javahandles.stim(idx,3),'Position',[.54 (num_stim-idx+1)/(num_stim+2) .1 1/(num_stim+2)]);
end



set(Javahandles.JpanelCont,'visible','on');
set(parent,'UserData',Javahandles);


return


function markstim(varargin)
i=get(gcbo,'userdata')+1;

    try
        mhandles = guihandles(findobj('tag', 'cw6figure'));
        system = get(mhandles.AquistionButtons, 'Userdata');
        if(~strcmp(isrunning(system.MainDevice), 'on'))
            return
        else
            Cw6_data = get(mhandles.cw6figure, 'UserData');
            mark = Cw6_data.data.raw_t(end);
        end
    catch
        display('Error Connecting.');
        mark = NaN;
    end

    if isequal(get(gcbo, 'Style'), 'togglebutton')
        if get(gcbo, 'Value')
             Cw6_data.data.StimDesign(i).onset=[Cw6_data.data.StimDesign(i).onset mark];
             Cw6_data.data.StimDesign(i).dur=[Cw6_data.data.StimDesign(i).dur 1000];
        else
            Cw6_data.data.StimDesign(i).dur(end)=mark-Cw6_data.data.StimDesign(i).onset(end);
        end
    end

        if(isempty(Cw6_data.data.stim{i}))
            Cw6_data.data.stim{i}(1)=mark;
        else
            Cw6_data.data.stim{i}(end+1)=mark;
        end
    
    try
       set(mhandles.cw6figure, 'UserData', Cw6_data);
    catch
        display('Error Saving.');
    end
    
    
       
 handles=guihandles(gcbo);   
numStim=str2num(get(handles.NumberStimuliText,'string'));
set(handles.NumberStimuliText,'string',num2str(numStim+1));
   
return











