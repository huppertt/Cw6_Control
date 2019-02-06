function GUIChangeDetector_callback(Tab,Det)

global NUM_DET;
global NUM_SRC;
global MAX_DET_GAIN;

MAXGAIN=MAX_DET_GAIN;
MINGAIN=0;

value=get(gcbo,'value');

if(value>MAXGAIN)
    value=MAXGAIN;
end
if(value<MINGAIN)
    value=MINGAIN;
end

Javahandles=get(findobj('tag','DetTabContainer'),'UserData');
 

handles=guihandles(findobj('tag','cw6figure'));
SubjInfo=get(handles.RegistrationInfo,'UserData');

if(~isstruct(Javahandles) | isempty(SubjInfo))
    %Things not loaded yet
    set(Javahandles.spinner(Tab,Det),'Value',0);
    set(Javahandles.slider(Tab,Det),'Value',0);
    return
end

if(get(Javahandles.spinner(Tab,Det),'Value')~=value)
    set(Javahandles.spinner(Tab,Det),'Value',value);     
end
if(get(Javahandles.slider(Tab,Det),'Value')~=value)
    set(Javahandles.slider(Tab,Det),'Value',value);
end

Cw6_BackEnd('SetGain'); 
updateSNR;
    

return