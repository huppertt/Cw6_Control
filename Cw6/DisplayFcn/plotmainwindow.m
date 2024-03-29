function plotmainwindow
handles=guihandles(findobj('tag','cw6figure'));

Cw6_data = get(handles.cw6figure,'UserData');

SubjInfo=get(handles.RegistrationInfo,'UserData');
SD=SubjInfo.Probe;

if(~isfield(SD,'mlMap'))
    %Haven't started data ever
    return
end

if(isempty(Cw6_data) | isempty(Cw6_data.data.raw))
    return
end

PlotLst=SubjInfo.SDGdisplay.PlotLst;

numMeas=size(SD.MeasList,1);
LineHandles=get(handles.MainPlotWindow,'UserData');
if(isempty(LineHandles))
    axes(handles.MainPlotWindow);
    set(gca,'Color',[.95 .95 .95]);
    hold on;
    %First time through
    LineHandles.raw=zeros(numMeas,1);
    LineHandles.conc=zeros(numMeas,1);
    LineHandles.special=zeros(numMeas,1);
    c={'k' 'r' 'g' 'b' 'c' 'm'};
    for idx=1:6
        LineHandles.stim(idx)=plot(-10,-10,'color',c{idx},'Linewidth',2,'visible','off');
    end
    
    % Blocks for StimDesign
    for idx=1:6
        LineHandles.block(idx)=fill([-11 -11 -10 -10 -10],[0 1 1 0 0],c{idx});
    end
    
    set(LineHandles.stim,'UIContextMenu',handles.AddCommentTextCM);
    LineHandles.comments=plot(-10,-10,'color','m','Linewidth',6,'visible','off');
    set(LineHandles.comments,'UIContextMenu',handles.AddCommentTextCM);
    
    for idx=1:numMeas
        %mlIdx=SD.mlMap(idx);
         mlIdx=idx;
         axes(handles.MainPlotWindow);
        LineHandles.raw(idx)=plot(Cw6_data.data.raw_t,Cw6_data.data.raw(mlIdx,:));
        lambda=SD.MeasList(idx,4);
        idx2=mod(idx,numMeas/length(SD.Lambda));
        if(idx2==0); idx2=numMeas/length(SD.Lambda); end

        set(LineHandles.raw(idx),'color',SD.Colors(idx2,:));
        if(~isempty(find(PlotLst==idx)) & SubjInfo.SDGdisplay.MLAct(idx) & ...
                get(handles.WhichDisplay,'value')<=length(SD.Lambda))
            set(LineHandles.raw(idx),'visible','on');
        else
            set(LineHandles.raw(idx),'visible','off');
        end
        if(~isempty(Cw6_data.data.conc))
            axes(handles.MainPlotWindow);
            LineHandles.conc(idx)=plot(Cw6_data.data.raw_t,real(Cw6_data.data.conc(idx,:)));
              set(LineHandles.conc(idx),'color',SD.Colors(idx2,:));
            if(~isempty(find(PlotLst==idx)) & SubjInfo.SDGdisplay.MLAct(idx) & ...
                    get(handles.WhichDisplay,'value')>length(SD.Lambda) &...
                    get(handles.WhichDisplay,'value')-length(SD.Lambda)==lambda)
                set(LineHandles.conc(idx),'visible','on');
            else
                set(LineHandles.conc(idx),'visible','off');
            end
        end
    end
else
    for idx=1:numMeas
        %mlIdx=SD.mlMap(idx);
         mlIdx=idx;
        lambda=SD.MeasList(idx,4);
        set(LineHandles.raw(idx),'Ydata',Cw6_data.data.raw(mlIdx,:),...
            'Xdata',Cw6_data.data.raw_t);
        if(~isempty(Cw6_data.data.conc))
            set(LineHandles.conc(idx),'Ydata',Cw6_data.data.conc(idx,:),...
                'Xdata',Cw6_data.data.raw_t);
        end
        if(~isempty(find(PlotLst==idx)) & SubjInfo.SDGdisplay.MLAct(idx) & ...
                get(handles.WhichDisplay,'value')<=length(SD.Lambda))
            set(LineHandles.raw(idx),'visible','on');
        else
            set(LineHandles.raw(idx),'visible','off');
        end
        if(~isempty(find(PlotLst==idx)) & SubjInfo.SDGdisplay.MLAct(idx) & ...
                get(handles.WhichDisplay,'value')>length(SD.Lambda) &...
                get(handles.WhichDisplay,'value')-length(SD.Lambda)==lambda)
            set(LineHandles.conc(idx),'visible','on');
        else
            set(LineHandles.conc(idx),'visible','off');
        end
    end
    
    %Stim
    for idx=1:length(Cw6_data.data.stim)
        xd=[Cw6_data.data.stim{idx} Cw6_data.data.stim{idx}-.01 Cw6_data.data.stim{idx}+.01];
        yd=-1000+1E6*[ones(size(Cw6_data.data.stim{idx})) zeros(size(Cw6_data.data.stim{idx}-.05)) zeros(size(Cw6_data.data.stim{idx}+.05))];

        [xd,id]=sort(abs(xd));
        yd=yd(id);
        set(LineHandles.stim(idx),'Xdata',xd,'Ydata',yd);
    end
    
    %Comments
    xd=[Cw6_data.data.comment_times Cw6_data.data.comment_times-.1 Cw6_data.data.comment_times+.1];
    yd=-1000+2000*[ones(size(Cw6_data.data.comment_times))...
        zeros(size(Cw6_data.data.comment_times-.05)) zeros(size(Cw6_data.data.comment_times+.05))];
    
    [xd,id]=sort(xd);
    yd=yd(id);
    set(LineHandles.comments,'Xdata',xd,'Ydata',yd);
    
end
lstvisible=find(SubjInfo.SDGdisplay.MLAct(PlotLst)==1);

set(handles.MainPlotWindow,'UserData',LineHandles);
cTpt=Cw6_data.data.raw_t(end);
if(get(handles.WindowData,'value'))
    winlength=str2num(get(handles.WindowDataEdit,'string'));
    cTpMin=max([cTpt-winlength 0]);
    set(handles.MainPlotWindow,'XLim',[cTpMin cTpt+1]);
    lst=find(Cw6_data.data.raw_t>cTpMin & Cw6_data.data.raw_t<cTpt+1);
else
    set(handles.MainPlotWindow,'XLim',[0 cTpt+1]);
    lst=find(Cw6_data.data.raw_t>0 & Cw6_data.data.raw_t<cTpt+1);
    set(handles.rescale_now,'Userdata',0);
end

lstT=get(handles.rescale_now,'Userdata');
if(~isempty(lstT))
    lst=lst(find(Cw6_data.data.raw_t(lst)>=lstT));
end

if(get(handles.WhichDisplay,'value')>length(SD.Lambda))
    minY=min(min(real(Cw6_data.data.conc(PlotLst(lstvisible),lst))));
    maxY=max(max(real(Cw6_data.data.conc(PlotLst(lstvisible),lst))));
else
    minY=min(min(Cw6_data.data.raw(PlotLst(lstvisible),lst)));
    maxY=max(max(Cw6_data.data.raw(PlotLst(lstvisible),lst)));
end

if(minY==maxY)
    minY=minY-.1;
    maxY=maxY+.1;
end

minY=minY-.05*(maxY-minY);
maxY=maxY+.05*(maxY-minY);


try
    set(handles.MainPlotWindow,'YLim',[minY maxY]);
catch
    disp([minY maxY])
end
if(get(handles.ShowStimulus,'value'))
    set(LineHandles.stim,'visible','on');
else
    set(LineHandles.stim,'visible','off');
end

if(get(handles.ShowComments,'value'))
     set(LineHandles.comments,'visible','on');
else
    set(LineHandles.comments,'visible','off');
end


StimDesign=Cw6_data.data.StimDesign;


ymm=max(minY,0)+(maxY-minY)/20;

for idx=1:length(StimDesign)
    xd=get(LineHandles.block(idx),'Xdata');
    yd=get(LineHandles.block(idx),'Ydata');
    yd(end)=[];
    xd(end)=[];
    
    yd=yd/max(yd);
    for idx2=1:length(StimDesign(idx).onset)
        if(~ismember(StimDesign(idx).onset(idx2),xd))
            yd=[yd; 0; 1; 1; 0];
            xd=[xd; StimDesign(idx).onset(idx2); StimDesign(idx).onset(idx2);...
                StimDesign(idx).onset(idx2)+StimDesign(1).dur(idx2); StimDesign(idx).onset(idx2)+StimDesign(1).dur(idx2)];
        end
    end
    yd=[yd; 0];
    xd=[xd; cTpt];
    set(LineHandles.block(idx),'Ydata',yd*ymm,'Xdata',xd);
end


drawnow;




return


