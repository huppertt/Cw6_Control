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

set(Javahandles.JpanelCont,'visible','on');
set(parent,'UserData',Javahandles);


return











