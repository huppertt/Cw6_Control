function Javahandles=createDetTab(parent, numDetgroups)

global MAX_DET_GAIN;
MAXGAIN=MAX_DET_GAIN;
MINGAIN=0;

%parent=figure;
f=gcf;


%First make a panel to place the controls into
%[Javahandles.Jpanel,Javahandles.JpanelCont]=javacomponent(javax.swing.JPanel);
Javahandles.JpanelCont=uipanel;
set(Javahandles.JpanelCont,'Tag','DetContainer');
set(Javahandles.JpanelCont,'parent',parent);
set(Javahandles.JpanelCont,'units','normalized');
set(Javahandles.JpanelCont,'position',[0 0 1 1]);

parent2=Javahandles.JpanelCont;

%make AGC button
Javahandles.AGC=uicontrol('style','pushbutton','tag','AGC');

set(Javahandles.AGC,'units','normalized')
set(Javahandles.AGC,'string','Automatic Gain Adjust','Callback','AutoAdjustGain');
set(Javahandles.AGC,'parent',Javahandles.JpanelCont);
set(Javahandles.AGC,'position',[.02 .08 .15 .2]);

%Now adds lasers to Det page
Javahandles.ChangeAllLasers=uicontrol('style','pushbutton','tag','ChangeAllLasers',...
    'units','normalized');
set(Javahandles.ChangeAllLasers,'string','All Lasers On','visible','on');
set(Javahandles.ChangeAllLasers,'Callback',@SetAllLasers);
set(Javahandles.ChangeAllLasers,'UserData',0);
set(Javahandles.ChangeAllLasers,'parent',Javahandles.JpanelCont);
set(Javahandles.ChangeAllLasers,'position',[.02 .58 .15 .2]);

Javahandles.LaserLED=uicontrol('style','edit','tag','LaserLED');
set(Javahandles.LaserLED,'units','normalized');
set(Javahandles.LaserLED,'enable','off');
set(Javahandles.LaserLED,'BackgroundColor',[.6 .6 .6]);
set(Javahandles.LaserLED,'parent',Javahandles.JpanelCont);
set(Javahandles.LaserLED,'position',[.04 .6 .11 .05]);


%make uitab for detector controls
%[Javahandles.Jtabpanel,Javahandles.JtabpanelCont]=actxcontrol('MSComctlLib.TabStrip.2');
%[Javahandles.Jtabpanel,Javahandles.JtabpanelCont]=actxcontrol('COMCTL.TabStrip.1');
[Javahandles.Jtabpanel,Javahandles.JtabpanelCont]=javacomponent(javax.swing.JTabbedPane);


set(Javahandles.JtabpanelCont,'Tag','DetectorTabContainer');
set(Javahandles.JtabpanelCont,'parent',Javahandles.JpanelCont);

%activeX controls don't handle position info right
set(parent,'units','pixel');
posParent=get(parent,'position');
set(parent,'units','normalized');

pos(1)=posParent(1)+.25*posParent(3);
pos(2)=posParent(2)+.05*posParent(4);
pos(3)=.7*posParent(3);
pos(4)=.9*posParent(4);
posAll=pos;
%[0.2 .05 .78 .9]
set(Javahandles.JtabpanelCont,'units','pixel');
set(Javahandles.JtabpanelCont,'position',pos);
%set(Javahandles.Jtabpanel,'TabOrientation','fmTabOrientationTop');

set(Javahandles.JtabpanelCont,'parent',f);
set(Javahandles.JtabpanelCont,'units','normalized');
set(Javahandles.JtabpanelCont,'position',[.15 .06 .45 .28]);


% for idx=1:Javahandles.Jtabpanel.Tabs.Count
%     Javahandles.Jtabpanel.Tabs.Remove(1);
% end

set(Javahandles.JtabpanelCont,'units','normalized');

%Now Add tabs
 for idx=1:numDetgroups
       
%    Javahandles.Jtabpanel.Tabs.Add;
%    set(Javahandles.Jtabpanel.Tabs.Item(idx),'Caption',...
%         ['Detectors [' num2str((idx-1)*8+1) '-' num2str((idx)*8) ']' ]);
%     
   str=['Detectors [' num2str((idx-1)*8+1) '-' num2str((idx)*8) ']' ]; 
   Javahandles.Jtabpanel.add([],str); 
    
 %  [Javahandles.tab(idx),Javahandles.tabcont(idx)]=javacomponent(javax.swing.JPanel);
   Javahandles.tabcont(idx)=uipanel;
   set(Javahandles.tabcont(idx),'Tag',['DetPanelCont_' num2str(idx)]);
   set(Javahandles.tabcont(idx),'parent',Javahandles.JpanelCont);
   set(Javahandles.tabcont(idx),'units','normalized');
   set(Javahandles.tabcont(idx),'position',[.205 0.055 .8 .75]);
    
   hlink(idx)=linkprop(Javahandles.tabcont(idx),'visible');
   for Det=1:8
        pos=[.2+(Det-1)*.35/8 .08 0 0];
        [Javahandles.spinner(idx,Det),Javahandles.spinnerCont(idx,Det)]=javacomponent(javax.swing.JSpinner);%
       % Javahandles.spinner(idx,Det)=uicomponent('style','JSpinner');
 %       set(Javahandles.spinner(idx,Det),'tag',['DetSpinner_' num2str((idx-1)*8+Det)]);
        set(Javahandles.spinnerCont(idx,Det),'parent',parent2); %Javahandles.tabcont(idx));
        set(Javahandles.spinnerCont(idx,Det),'units','normalized');
        set(Javahandles.spinnerCont(idx,Det),'position',pos);
        UserData.type='Spinner';
        UserData.DetNum=8*(idx-1)+Det;              
        set(Javahandles.spinnerCont(idx,Det),'UserData',UserData);
        set(Javahandles.spinner(idx,Det),'value',0);
        set(Javahandles.spinner(idx,Det),'StateChangedCallback',['GUIChangeDetector_callback('...
             num2str(idx) ',' num2str(Det) ')']);
         hlink(idx).addtarget(Javahandles.spinnerCont(idx,Det));  
         set(Javahandles.spinnerCont(idx,Det), 'parent',f,'position',pos+[0 0 .04 .05]);     
         
        [Javahandles.slider(idx,Det),Javahandles.sliderCont(idx,Det)]=javacomponent(javax.swing.JSlider);%
        %Javahandles.slider(idx,Det)=uicomponent('style','JSlider');
       % set(Javahandles.slider(idx,Det),'tag',['DetSlider_' num2str((idx-1)*8+Det)]);
        set(Javahandles.slider(idx,Det),'orientation',1);
        set(Javahandles.sliderCont(idx,Det),'parent',parent2); %Javahandles.tabcont(idx));
        set(Javahandles.sliderCont(idx,Det),'units','normalized');
        set(Javahandles.sliderCont(idx,Det),'position',pos+[0 .1 0 .6]);
        set(Javahandles.slider(idx,Det),'Value',0);
        set(Javahandles.slider(idx,Det),'Maximum',MAXGAIN);
        set(Javahandles.slider(idx,Det),'Minimum',MINGAIN);
        set(Javahandles.slider(idx,Det),'StateChangedCallback',['GUIChangeDetector_callback('...
            num2str(idx) ',' num2str(Det) ')']);
        set(Javahandles.slider(idx,Det),'MouseWheelMovedCallback',@Slider_mousewheel);
        
        set(Javahandles.sliderCont(idx,Det), 'parent',f,'position',pos+[0 0.05 .04 .14]); 
            
        UserData.type='Slider';
        UserData.DetNum=8*(idx-1)+Det;              
        set(Javahandles.sliderCont(idx,Det),'UserData',UserData);
        hlink(idx).addtarget(Javahandles.sliderCont(idx,Det));   
          
        
        Javahandles.text(idx,Det)=uicontrol('style','text');
        set(Javahandles.text(idx,Det),'tag',['DetText_' num2str((idx-1)*8+Det)]);
        set(Javahandles.text(idx,Det),'parent',f); %Javahandles.tabcont(idx));
        set(Javahandles.text(idx,Det),'units','normalized');
        set(Javahandles.text(idx,Det),'string',num2str((idx-1)*8+Det));
        set(Javahandles.text(idx,Det),'position',pos+[0 .17 .04 .05]);
        hlink(idx).addtarget(Javahandles.text(idx,Det));
        
              
        Javahandles.LED(idx,Det)=uicontrol('style','edit');
        set(Javahandles.LED(idx,Det),'tag',['DetLED_' num2str((idx-1)*8+Det)]);
        set(Javahandles.LED(idx,Det),'parent',f); %Javahandles.tabcont(idx));
        set(Javahandles.LED(idx,Det),'units','normalized');
        set(Javahandles.LED(idx,Det),'position',pos+[0 0.175 .04 .01]);
        set(Javahandles.LED(idx,Det),'BackgroundColor','g');
        hlink(idx).addtarget(Javahandles.LED(idx,Det));
        
    end
set(Javahandles.tabcont(idx),'visible','off');
    
end

Javahandles.hlink=hlink;
set(parent,'UserData',Javahandles);

setSelectedIndex(Javahandles.Jtabpanel,0);
set(Javahandles.Jtabpanel,'StateChangedCallback', @switchtab);
%registerevent(Javahandles.Jtabpanel,{'Click' @switchtab});

for idx=2:length(Javahandles.hlink)
    set(Javahandles.hlink(idx).Targets,'visible','on');
end

set(Javahandles.hlink(1).Targets,'visible','on');
set(Javahandles.JpanelCont,'visible','on');
switchtab(Javahandles.Jtabpanel);
return
% 
% function switchtab(varargin)
% 
% selectedIdx=getSelectedIndex(varargin{1})+1; %varargin{1}.SelectedItem.Index;
% Javahandles=get(get(findobj('tag','DetContainer'),'parent'),'UserData');
% 
% for idx=1:length(Javahandles.tabcont)
%     if(idx~=selectedIdx)
%         set(Javahandles.hlink(idx).Targets,'visible','off');
%     end
% end
% set(Javahandles.hlink(selectedIdx).Targets,'visible','on');
% 
% 
% return

function Slider_mousewheel(varargin)

scroll=get(varargin{2},'WheelRotation');
if(scroll==0)
    scroll=1;
end
scroll=-scroll;
comp=get(varargin{2},'Component');
value=get(comp(1),'Value');

if((get(comp(1),'Minimum')<=value+scroll) & (get(comp(1),'Maximum')>=value+scroll))
    set(comp(1),'Value',value+scroll);
end
return
