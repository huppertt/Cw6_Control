function switchtab(varargin)

selectedIdx=getSelectedIndex(varargin{1})+1; %varargin{1}.SelectedItem.Index;
Javahandles=get(get(findobj('tag','DetContainer'),'parent'),'UserData');

for idx=1:length(Javahandles.tabcont)
    if(idx~=selectedIdx)
        set(Javahandles.hlink(idx).Targets,'visible','off');
    end
end
set(Javahandles.hlink(selectedIdx).Targets,'visible','on');


return
