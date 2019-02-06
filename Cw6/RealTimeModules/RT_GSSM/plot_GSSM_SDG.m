function plot_GSSM_SDG(called_from_child)

handles=guihandles(findobj('tag','GSSM_Figure'));

GSSM_data=get(handles.GSSM_Figure,'Userdata');
SD=GSSM_data.SD;

if(~exist('called_from_child'))
    called_from_child=0;
end

if(~isfield(GSSM_data,'StatsChannels'))
    GSSM_data.StatsChannels=ones(size(SD.MeasList,1),1);
end

axes(handles.PlotSGD_GSSM);
hold on;
cla

distances=[];
    ml=SD.MeasList;
    lst=find(ml(:,4)==1);
    
    for idx=1:length(lst)
        SrcPos=SD.SrcPos(ml(lst(idx),1),:);
        DetPos=SD.DetPos(ml(lst(idx),2),:);
        
        dist=norm(SrcPos-DetPos);
        distances=[distances; dist];
    end

    meanSD=mean(distances);
    
xmin = min( [SD.SrcPos(:,1); SD.DetPos(:,1)] -1/2*meanSD);
xmax = max( [SD.SrcPos(:,1); SD.DetPos(:,1)] +1/2*meanSD);
ymin = min( [SD.SrcPos(:,2); SD.DetPos(:,2)] -1/2*meanSD);
ymax = max( [SD.SrcPos(:,2); SD.DetPos(:,2)] +1/2*meanSD);

axis( [xmin xmax ymin ymax]);

%SD.Colors=jet(size(ml,1)/length(SD.Lambda));


if(~isfield(SD,'PlotLst'))
    SD.PlotLst=find(ml(:,1)==1);
end
if(~isfield(SD,'MeasListAct'))
    SD.MeasListAct=ones(size(ml,1),1);
end

m=size(ml,1)./length(SD.Lambda);
for idx=1:size(ml,1)
    if(ml(idx,4)~=1)
       continue;
    end
    SrcPos=SD.SrcPos(ml(idx,1),:);
    DetPos=SD.DetPos(ml(idx,2),:);
   
    idx2=mod(idx,m);
    if(idx2==0); idx2=m; end 
    l=line([SrcPos(1) DetPos(1)],[SrcPos(2) DetPos(2)]);
    
    set(l,'color',SD.Colors(idx2,:));
   
    set(l,'UserData',idx);
    if(isempty(find(SD.PlotLst==idx)))
        set(l,'LineWidth',1);
    else
        set(l,'LineWidth',4);
         set(l,'ButtonDownFcn',@togglelines);
         
         if(SD.MeasListAct(idx))
            set(l,'LineStyle','-');
            
         else
             set(l,'LineStyle','--');
           
         end
         
    end
end


%Plot the SDG
for Sidx=1:size(SD.SrcPos,1)
    h=text(SD.SrcPos(Sidx,1),SD.SrcPos(Sidx,2),['S-' num2str(Sidx)]);
    set(h,'FontSize',12,'color','k');
    set(h,'ButtonDownFcn',@toggleSrc);
    set(h,'UserData',Sidx);
end
for Didx=1:size(SD.DetPos,1)
    h=text(SD.DetPos(Didx,1),SD.DetPos(Didx,2),['D-' num2str(Didx)]);
    set(h,'FontSize',12,'color','k');
    set(h,'ButtonDownFcn',@toggleDet);
    set(h,'UserData',Didx);
end

GSSM_data=get(handles.GSSM_Figure,'Userdata');
GSSM_data.SD=SD;
set(handles.GSSM_Figure,'Userdata',GSSM_data);
plot_GSSM_main(called_from_child);

return

function togglelines(varargin)
handles=guihandles(findobj('tag','GSSM_Figure'));
GSSM_data=get(handles.GSSM_Figure,'Userdata');
Idx=get(varargin{1},'UserData');
GSSM_data.SD.MeasListAct(Idx)= ~GSSM_data.SD.MeasListAct(Idx);

idx2=find(GSSM_data.SD.MeasList(:,1)==GSSM_data.SD.MeasList(Idx,1) &...
    GSSM_data.SD.MeasList(:,2)==GSSM_data.SD.MeasList(Idx,2));
GSSM_data.SD.MeasListAct(idx2)=GSSM_data.SD.MeasListAct(Idx);

set(handles.GSSM_Figure,'Userdata',GSSM_data);
plot_GSSM_SDG(1);


function toggleSrc(varargin)

handles=guihandles(findobj('tag','GSSM_Figure'));
GSSM_data=get(handles.GSSM_Figure,'Userdata');
Idx=get(varargin{1},'UserData');
GSSM_data.SD.PlotLst=find(GSSM_data.SD.MeasList(:,1)==Idx);
set(handles.GSSM_Figure,'Userdata',GSSM_data);
plot_GSSM_SDG(1);

function toggleDet(varargin)

handles=guihandles(findobj('tag','GSSM_Figure'));
GSSM_data=get(handles.GSSM_Figure,'Userdata');
Idx=get(varargin{1},'UserData');
GSSM_data.SD.PlotLst=find(GSSM_data.SD.MeasList(:,2)==Idx);
set(handles.GSSM_Figure,'Userdata',GSSM_data);
plot_GSSM_SDG(1);

