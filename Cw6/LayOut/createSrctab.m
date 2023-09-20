function Javahandles=createSrctab(parent,NUMSOURCES)

global BOOL_ADJ_LASERS;  
global MAX_LASER_INTEN;


%First make a panel to place the controls into
[Javahandles.Jpanel,Javahandles.JpanelCont]=javacomponent(javax.swing.JPanel);
set(Javahandles.JpanelCont,'Tag','SrcContainer');
set(Javahandles.JpanelCont,'parent',parent);
set(Javahandles.JpanelCont,'units','normalized');
set(Javahandles.JpanelCont,'position',[0 0 1 1]);

Javahandles.ChangeAllLasers=uicontrol('style','pushbutton','tag','ChangeAllLasers',...
    'units','normalized','parent',Javahandles.JpanelCont);
set(Javahandles.ChangeAllLasers,'string','All Lasers On','visible','on','position',[.02 .58 .15 .2]);
set(Javahandles.ChangeAllLasers,'Callback',@SetAllLasers);
set(Javahandles.ChangeAllLasers,'UserData',0);

Javahandles.LaserLED=uicontrol('style','edit','tag','LaserLED','parent',Javahandles.JpanelCont);
set(Javahandles.LaserLED,'units','normalized');
set(Javahandles.LaserLED,'enable','off');
set(Javahandles.LaserLED,'position',[.04 .6 .11 .05]);
set(Javahandles.LaserLED,'BackgroundColor',[.6 .6 .6]);

numgroups=max(floor(NUMSOURCES/8),1);

hlink=linkprop(Javahandles.JpanelCont,'visible');

cnt=1;
for idx=1:numgroups
    for laser=1:8
        pos=[.3 .1 .7/(numgroups+2) .7/8]+(idx-1)*[.7/(numgroups+2) 0 0 0]+...
            (8-laser)*[0 .7/8 0 0]+floor(idx/3)*[.7/(numgroups+2) 0 0 0];
        if(mod(idx,2)==1)
            wavelength='690';
        else
            wavelength='830';
        end
        Javahandles.Lasers(cnt)=uicontrol('style','pushbutton','tag',['Laser_' num2str(cnt)],...
        'units','normalized');
           set(Javahandles.Lasers(cnt),'string',['Laser ' num2str(cnt) ' (' wavelength 'nm )'],...
               'position',pos,'visible','on');
         set(Javahandles.Lasers(cnt),'Callback',@SetLaser);  
         set(Javahandles.Lasers(cnt),'UserData',0);
         set(Javahandles.Lasers(cnt),'parent',Javahandles.JpanelCont);
        
         if(BOOL_ADJ_LASERS)
             Javahandles.spinner(cnt)=uicomponent('style','JSpinner','tag',['LaserIntenSpinner_' num2str(cnt)],...
                 'units','normalized');
%             [Javahandles.spinner(cnt),Javahandles.spinnerContainer(cnt)]=javacomponent(javax.swing.JSpinner);
            set(Javahandles.spinner(cnt),'tag',['LaserIntenSpinner_' num2str(cnt)],'units','normalized');
            pos2=pos;
            pos2(3)=pos(3)/4;
            pos2(4)=pos(4)*.8;
            
            p=get(Javahandles.JpanelCont,'position');
            pos2(1)=p(1)+p(3)*pos2(1);
            pos2(2)=p(2)+p(4)*pos2(2);
            pos2(3)=p(3)*pos2(3);
            pos2(4)=p(4)*pos2(4);
            
            set(Javahandles.spinner(cnt),'position',pos2);
           
            set(Javahandles.spinner(cnt),'StateChangedCallback',['GUIChangeLaserInten_callback']);
            set(Javahandles.spinner(cnt),'value',MAX_LASER_INTEN);
            hlink.addtarget(Javahandles.spinner(cnt));
            set(Javahandles.spinner(cnt),'parent',Javahandles.JpanelCont);
            uistack(Javahandles.spinner(cnt),'top');
         end
         
        hlink.addtarget(Javahandles.Lasers(cnt));
        cnt=cnt+1;
    end
end
set(Javahandles.JpanelCont,'visible','on');
set(parent,'UserData',Javahandles);

return











