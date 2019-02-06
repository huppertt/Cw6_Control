function Cw6_MenuFunctions(varargin)

if ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

%     try
        [varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
%     catch
%         disp(lasterr);
%     end

end

return



% --------------------------------------------------------------------
function NewSubject_Callback(hObject, eventdata, handles)
h=RegisterSubject;
moniterpos=get(0,'MonitorPositions');
set(h,'units','pixels');
if(size(moniterpos,1)>1)
    try; set(h,'position',get(h,'position')+[moniterpos(2,1) 0 0 0]); end;
end


% --------------------------------------------------------------------
function SystemInfo_Menu_Callback(hObject, eventdata, handles)

global SYSTEM_TYPE;

handles=guihandles(findobj('tag','cw6figure'));
system=get(handles.AquistionButtons,'Userdata');
str='';

switch(SYSTEM_TYPE)
    case('NIRS2')
        str=sprintf(['%sSystem: NIRS 2x4 System\n',...
            'Version 2.0  (2009)\n',...
            'TechEn Inc.  Milford MA'],str);
    case('CW6')
        str=sprintf(['%s\nSystem: CW6 32x32 System\n',...
            'Version 1.0  (2009)\n',...
            'TechEn Inc.  Milford MA'],str);
    otherwise
end

if(isstruct(system))
    str=sprintf('%s\n-----------------------------------------------\n%s',str,...
        ['Main System sample rate: ' num2str(getdatarate(system.MainDevice)) 'Hz']);
    if(~isempty(system.AuxDevice))
        str=sprintf('%s\n%s',str,...
            ['Auxillary System sample rate: ' num2str(getdatarate(system.AuxDevice)) 'Hz']);
    end
end
str=sprintf(['%s\n-----------------------------------------------\n\n',...
    'Data Aquistion Software Version 0.2\n',...
    'T. Huppert (2009)'],str);

h=msgbox(str);
moniterpos=get(0,'MonitorPositions');
set(h,'units','pixels');
%set(h,'position',get(h,'position')+[moniterpos(2,1) 0 0 0]);

uiwait(h);
return

% --------------------------------------------------------------------
function Help_Menu_Callback(hObject, eventdata, handles)
%Launch HELP PDF support
PDFfile='CW6_HELP.pdf';
open(PDFfile);

% --------------------------------------------------------------------
function About_Menu_Callback(hObject, eventdata, handles)
%The about message.
msg=sprintf('%s\n%s\n%s\n%s\n',...
    'NIRS Data Aquistion Software Version 1.0',...
    'Written by T. Huppert',...
    'University of Pittsburgh',...
    'July 16th, 2009');

h=msgbox(msg);

moniterpos=get(0,'MonitorPositions');
set(h,'units','pixels');
%set(h,'position',get(h,'position')+[moniterpos(2,1) 0 0 0]);


uiwait(h);
return


% --------------------------------------------------------------------
function RTProcessing_Callback(hObject, eventdata, handles)
% hObject    handle to RTProcessing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=RealTimeFilterSetupMenu;
moniterpos=get(0,'MonitorPositions');
set(h,'units','pixels');

%set(h,'position',get(h,'position')+[moniterpos(2,1) 0 0 0]);
