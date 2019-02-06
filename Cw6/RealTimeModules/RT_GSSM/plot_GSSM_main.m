function plot_GSSM_main(called_from_child)

persistent lasttimeplotted

if(~exist('called_from_child'))
    called_from_child=0;
end
handles=guihandles(findobj('tag','GSSM_Figure'));
GSSM_data=get(handles.GSSM_Figure,'Userdata');

SD=GSSM_data.SD;

persistent childlines;

numMeas=size(SD.MeasList,1);

try
    if(isempty(childlines) || isempty(get(handles.PlotGSSM_Main,'children')) || isempty(GSSM_data.time))
        axes(handles.PlotGSSM_Main);
        cla
        hold on;
        for idx=1:size(SD.MeasList,1);
            
            if(SD.MeasList(idx,4)~=1)
                idx1=find(SD.MeasList(:,1)==SD.MeasList(idx,1) &...
                SD.MeasList(:,2)==SD.MeasList(idx,2) &...
                SD.MeasList(:,4)==1);
                idx2=mod(idx1,numMeas/length(SD.Lambda));
                if(idx2==0); idx2=numMeas/length(SD.Lambda); end
            else
                idx2=mod(idx,numMeas/length(SD.Lambda));
                if(idx2==0); idx2=numMeas/length(SD.Lambda); end 
            end
            childlines(idx)=plot(0,0);
            
            set(childlines(idx),'Linewidth',1);
            set(childlines(idx),'color',SD.Colors(idx2,:));
            set(childlines(idx),'visible','off');
            if(SD.MeasList(idx,4)==1)
                set(childlines(idx),'LineStyle','-');
            else
                set(childlines(idx),'LineStyle','--');
            end
        end
        plotImages;
        lasttimeplotted=0;
        return
    end


    
    time=GSSM_data.time;
    if(isempty(time) || time(1)==NaN)
        return
    end
    
    if(~called_from_child)
        if(time(end)-lasttimeplotted<.5)
            return;
        else
            lasttimeplotted=time(end);
        end
    end

dspchoice=get(handles.WhichDisplay,'value');
if(dspchoice==1)
    HbX=GSSM_data.data;
elseif(dspchoice==2)
    HbX=GSSM_data.beta;
else
    HbX=GSSM_data.Ttest;
end
HbX=real(HbX);
       
    for idx=1:size(SD.MeasList,1);
        set(childlines(idx),'Xdata',time,'Ydata',HbX(idx,:));
        if(GSSM_data.SD.MeasListAct(idx) & ~isempty(find(SD.PlotLst==idx))) 
            if(SD.MeasList(idx,4)==1 & get(handles.ShowHbO,'value'))
                set(childlines(idx),'visible','on');
            elseif(SD.MeasList(idx,4)==2 & get(handles.ShowHbR,'value'))
                set(childlines(idx),'visible','on');
            else
                set(childlines(idx),'visible','off');
            end
        else
            set(childlines(idx),'visible','off');
        end
    end
   
end

Tend=time(end);
if(get(handles.WindowData,'value'))
    Tstart=max([0 Tend-str2num(get(handles.edit1,'string'))]);
    lst=find(time>=Tstart);
else
    lst=find(time>time(1));
    Tstart=time(1);
end

Xrange=[999 -999];

if(get(handles.ShowHbO,'value'))
    lstplot=find(GSSM_data.SD.MeasListAct(SD.PlotLst)==1 &...
        GSSM_data.SD.MeasList(SD.PlotLst,4)==1);
    if(~isempty(lstplot))
        Xrange(1)=min([min(min(HbX(SD.PlotLst(lstplot),lst))) Xrange(1)]);
        Xrange(2)=max([max(max(HbX(SD.PlotLst(lstplot),lst))) Xrange(2)]);
    end
end
if(get(handles.ShowHbR,'value'))
    lstplot=find(GSSM_data.SD.MeasListAct(SD.PlotLst)==1 &...
        GSSM_data.SD.MeasList(SD.PlotLst,4)==2);
     if(~isempty(lstplot))
        Xrange(1)=min([min(min(HbX(SD.PlotLst(lstplot),lst))) Xrange(1)]);
        Xrange(2)=max([max(max(HbX(SD.PlotLst(lstplot),lst))) Xrange(2)]);
     end
end


if(Xrange(2)==-999)
    Xrange(2)=.1;
end
if(Xrange(1)==999)
    Xrange(1)=-.1;
end

if(Xrange(1)==Xrange(2))
    Xrange(2)=Xrange(2)+.1;
end

if(Tstart~=Tend)
    Xrange(1)=Xrange(1)-.1*(Xrange(2)-Xrange(1));
    Xrange(2)=Xrange(2)+.1*(Xrange(2)-Xrange(1));
    axis(handles.PlotGSSM_Main,[Tstart Tend Xrange(1) Xrange(2)]);
end

plotImages(called_from_child);

return