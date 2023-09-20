function handles=LayOutFunction(handles)

global NUM_SRC;
global NUM_DET;
global SyncControl;
global DigitalAux;
global NIOutput;

set(handles.cw6figure,'visible','off')
figure(handles.cw6figure);

moniters=get(0,'MonitorPositions');
%moniters(end,1)=moniters(end,1)-moniters(end,3)*2;
set(handles.cw6figure,'units','pixels');

moniters(:,3)=moniters(:,3)-moniters(:,1);
moniters(:,4)=moniters(:,4)-moniters(:,2);
% 
% a=20; 
% moniters(end,1)=moniters(end,1)+a;
% moniters(end,2)=moniters(end,2)+a;
% moniters(end,3)=moniters(end,3)-a;
% moniters(end,4)=moniters(end,4)-a;
% 
% 
% set(handles.cw6figure,'position',moniters(end,:));

set(handles.cw6figure,'visible','off');
set(gcf,'name','NIRS Data Aquisition Version l.0');
import com.mathworks.mde.desk.*
d = MLDesktop.getInstance;
f = d.getClient('NIRS');
try
    if(isempty(f))
        c=get(d,'clients');
        for i=1:length(c)
            if(~isempty(strfind(c{i},'NIRS')))
                break;
            end
        end
        f = d.getClient(c{i});
    end

%     img=javax.swing.ImageIcon('Splash.jpg');
%     r = f.getRootPane;
%     rp = r.getParent;
%     rp.setIcon(img);
end

%make uitab for detector controls
%[Javahandles.Jtabpanel,Javahandles.Jtabpanelactivex2]=actxcontrol('MSComctlLib.TabStrip.2');
%[Javahandles.Jtabpanel,Javahandles.Jtabpanelactivex2]=actxcontrol('COMCTL.TabStrip.1');

[Javahandles.Jtabpanel,Javahandles.Jtabpanelactivex2]=javacomponent(javax.swing.JTabbedPane);
set(Javahandles.Jtabpanelactivex2,'tag','noname2');

set(Javahandles.Jtabpanelactivex2,'units',get(handles.tabholder1,'units'));
set(Javahandles.Jtabpanelactivex2,'position',get(handles.tabholder1,'position'));
set(handles.tabholder1,'units','normalized');
set(Javahandles.Jtabpanelactivex2,'units','normalized');

%set(Javahandles.Jtabpanel,'Placement','tabPlacementLeft');
Tabs=Javahandles.Jtabpanel;
Tabs.add([],'Detectors');
Tabs.add([],'Lasers');
Tabs.add([],'Auxillary');

setSelectedIndex(Javahandles.Jtabpanel,0);

try
    %This is the device for sending the pulse out on start
    warning('off','daq:analogoutput:adaptorobsolete');
    [SyncControl,SyncControlCont]=actxcontrol('NIDATALOGGER.NIDataLoggerCtrl.1');
    set(SyncControlCont,'visible','off');
    set(SyncControlCont,'position',[1 1 1 1]);
end

try
    %This is the device for sending the pulse out on start
    DigitalAux=digitalio('nidaq',1);
    addline(DigitalAux,[0:7],'In');
    NIOutput=analogoutput('nidaq',1);
    addchannel(NIOutput,0);
end

set(handles.tabholder1,'units','pixels');
pos=get(handles.tabholder1,'position');
set(handles.tabholder1,'units','normalized');
pos(1)=pos(1)+.05*pos(3);
pos(2)=pos(2)+.05*pos(4);
pos(3)=pos(3)*.9;
pos(4)=pos(4)*.8;



set(handles.TabContainer,'units','normalized');
%Make Detector Tab
[DetTab,DetTabContainer]=javacomponent(javax.swing.JPanel);

set(DetTabContainer,'units','pixels');
set(DetTabContainer,'position',pos);
%set(DetTabContainer,'units','normalized');
set(DetTabContainer,'tag','DetTabContainer');
DetJavaHandles=createDetTab(DetTabContainer, ceil(NUM_DET/8));
set(DetTabContainer,'UserData',DetJavaHandles);


%Make Source Tab
[SrcTab,SrcTabContainer]=javacomponent(javax.swing.JPanel);
set(SrcTabContainer,'units','pixels');
set(SrcTabContainer,'position',pos);
set(SrcTabContainer,'tag','SrcTabContainer');
SrcJavaHandles=createSrctab(SrcTabContainer,NUM_SRC);
set(SrcTabContainer,'UserData',SrcJavaHandles);
set(SrcTabContainer,'units','normalized');
% 
% 
% % %Make Aux Tab Tab
[AuxTab,AuxTabContainer]=javacomponent(javax.swing.JPanel);
set(AuxTabContainer,'units','pixels');
set(AuxTabContainer,'position',pos);
set(AuxTabContainer,'tag','AuxTabContainer');
AuxJavaHandles=createAuxtab(AuxTabContainer);
set(AuxTabContainer,'UserData',AuxJavaHandles);
set(AuxTabContainer,'units','normalized');

set(Javahandles.Jtabpanel,'StateChangedCallback', @SwitchTabAll);
%registerevent(Javahandles.Jtabpanel,{'Click',@SwitchTab});

tabswitch.SelectedItem.Index=1;
SwitchTabAll(tabswitch);

set(handles.cw6figure,'visible','on');


%Maximize the window
set(handles.cw6figure,'units','pixels');



% 
% moniters=get(0,'MonitorPositions');
% moniters(:,3)=moniters(:,3)-moniters(:,1);
% moniters(:,4)=moniters(:,4)-moniters(:,2);
% 
% %set(handles.cw6figure,'position',moniters(1,:));
% %if(size(moniters,1)>1)
%     set(handles.cw6figure,'position',moniters(end,:));
% % else
% %     set(handles.cw6figure,'position',[1 10 1024 730]);
% % end

[ProgressBar,ProgressBarContainer]=javacomponent(javax.swing.JProgressBar);
set(ProgressBarContainer,'parent',handles.AquistionButtons);
set(ProgressBarContainer,'units','normalized');
set(ProgressBarContainer,'position',[.02 .4 .64 .3]);
set(ProgressBarContainer,'tag','Cw6Progress');
set(ProgressBarContainer,'userdata',ProgressBar);



% Create a pushbutton to hide the laser/detector controls
    hideControls=uicontrol('Style','pushbutton','tag','hidecontrols');
    set(hideControls,'String','Hide Controls');
    set(hideControls,'Units','Normalized','Position',[.57 .38 .06 .05]);
    set(hideControls,'Callback',@hidecontrols);
    
    a(1)=Javahandles.Jtabpanelactivex2;
    a(2)=AuxTabContainer;
    a(3)=DetTabContainer;
    a(4)=SrcTabContainer;
    a(5)=DetJavaHandles.JtabpanelCont;
    
    set(hideControls,'UserData',a);
set(handles.TabContainer,'visible','off')
set(handles.tabholder1,'visible','off');

return
    
    
function hidecontrols(varargin)
handles=guihandles(gcbo);
a=get(gcbo,'Userdata');
if(all(get(gcbo,'Position')==[.57 .38 .06 .05]))
   set(a,'visible','off');
   set(gcbo,'Position',[.57 .05 .06 .05]);
   set(handles.MainPlotWindow,'Position',[0.0611 0.1563  0.5705 0.5377+.3]);
   set(gcbo,'String','Show Controls');
else
    set(a,'visible','on');
    set(gcbo,'Position',[.57 .38 .06 .05]);
    set(handles.MainPlotWindow,'Position',[0.0611    0.4563    0.5705    0.5377]);
    set(gcbo,'String','Hide Controls');
    us=get(a(3),'userdata')
    SwitchTabAll(us.Jtabpanel);
end
return

function SwitchTabAll(varargin)

try
    selectedIdx=varargin{1}.SelectedItem.Index;
catch
    selectedIdx=getSelectedIndex(varargin{1})+1; 
end

DetTabContainer=findobj('tag','DetTabContainer');
SrcTabContainer=findobj('tag','SrcTabContainer');
AuxTabContainer=findobj('tag','AuxTabContainer');

switch(selectedIdx)
    case(0)
         set(DetTabContainer,'visible','off');
        set(SrcTabContainer,'visible','off');
        set(AuxTabContainer,'visible','off');
        set(get(SrcTabContainer,'children'),'visible','off');
         set(get(AuxTabContainer,'children'),'visible','off');
          c=get(get(SrcTabContainer,'children'),'children');
         if(iscell(c)); 
             c=vertcat(c{:});
         end
        
        set(c,'visible','off');
%         c=get(get(DetTabContainer,'children'),'children');
%         set(c,'visible','on');
  global BOOL_ADJ_LASERS;
        if(BOOL_ADJ_LASERS)
            handles=guihandles(findobj('tag','cw6figure'));
            c(1)=handles.LaserIntenSpinner_1;
            c(2)=handles.LaserIntenSpinner_2;
            c(3)=handles.LaserIntenSpinner_3;
            c(4)=handles.LaserIntenSpinner_4;
            c(5)=handles.LaserIntenSpinner_5;
            c(6)=handles.LaserIntenSpinner_6;
            c(7)=handles.LaserIntenSpinner_7;
            c(8)=handles.LaserIntenSpinner_8;
            set(c,'visible','off');
        end        


    case(1)
        set(DetTabContainer,'visible','on');
        set(SrcTabContainer,'visible','off');
        set(AuxTabContainer,'visible','off');
        set(get(SrcTabContainer,'children'),'visible','off');
         set(get(AuxTabContainer,'children'),'visible','off');
          c=get(get(SrcTabContainer,'children'),'children');
         if(iscell(c)); 
             c=vertcat(c{:});
         end
        
        set(c,'visible','off');
%         c=get(get(DetTabContainer,'children'),'children');
%         set(c,'visible','on');
  global BOOL_ADJ_LASERS;
        if(BOOL_ADJ_LASERS)
            handles=guihandles(findobj('tag','cw6figure'));
            c(1)=handles.LaserIntenSpinner_1;
            c(2)=handles.LaserIntenSpinner_2;
            c(3)=handles.LaserIntenSpinner_3;
            c(4)=handles.LaserIntenSpinner_4;
            c(5)=handles.LaserIntenSpinner_5;
            c(6)=handles.LaserIntenSpinner_6;
            c(7)=handles.LaserIntenSpinner_7;
            c(8)=handles.LaserIntenSpinner_8;
            set(c,'visible','off');
        end        


    case(2)
        set(SrcTabContainer,'visible','on');
        set(get(SrcTabContainer,'children'),'visible','on');
        c=get(get(SrcTabContainer,'children'),'children');
        if(iscell(c)); 
             c=vertcat(c{:});
         end
        set(c,'visible','on');
        set(DetTabContainer,'visible','off');
        set(get(AuxTabContainer,'children'),'visible','off');
        set(AuxTabContainer,'visible','off');
        
        global BOOL_ADJ_LASERS;
        if(BOOL_ADJ_LASERS)
            handles=guihandles(findobj('tag','cw6figure'));
            c(1)=handles.LaserIntenSpinner_1;
            c(2)=handles.LaserIntenSpinner_2;
            c(3)=handles.LaserIntenSpinner_3;
            c(4)=handles.LaserIntenSpinner_4;
            c(5)=handles.LaserIntenSpinner_5;
            c(6)=handles.LaserIntenSpinner_6;
            c(7)=handles.LaserIntenSpinner_7;
            c(8)=handles.LaserIntenSpinner_8;
            set(c,'visible','on');
        end
        
        
    case(3)
        set(DetTabContainer,'visible','off');
        set(SrcTabContainer,'visible','off');
        set(AuxTabContainer,'visible','on');
        set(get(SrcTabContainer,'children'),'visible','off');
        set(get(AuxTabContainer,'children'),'visible','on');
%         c=get(get(AuxTabContainer,'children'),'children');
%         set(c,'visible','on');
  global BOOL_ADJ_LASERS;
        if(BOOL_ADJ_LASERS)
            handles=guihandles(findobj('tag','cw6figure'));
            c(1)=handles.LaserIntenSpinner_1;
            c(2)=handles.LaserIntenSpinner_2;
            c(3)=handles.LaserIntenSpinner_3;
            c(4)=handles.LaserIntenSpinner_4;
            c(5)=handles.LaserIntenSpinner_5;
            c(6)=handles.LaserIntenSpinner_6;
            c(7)=handles.LaserIntenSpinner_7;
            c(8)=handles.LaserIntenSpinner_8;
            set(c,'visible','off');
        end


end

return