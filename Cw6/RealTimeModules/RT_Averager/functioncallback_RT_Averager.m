function [time,data,auxdata,concdata]=onlineaverager(time,data,auxdata,concdata,stim)

%the stimulus will always be the first aux channel since the aux data is
%augmented to include a binary stim vector here.

persistent AvgData

if(isempty(data))
    AvgData=[];
    return;
end

if(isempty(stim))
    AvgData=[];
     if(isempty(findobj('tag','RT_averager')))
        figure('tag','RT_averager');
     else
          figure(findobj('tag','RT_averager'));
          cla;
          
    end
    return
end

handles=guihandles(findobj('tag','cw6figure'));
SubjInfo=get(handles.RegistrationInfo,'UserData');
SD=SubjInfo.Probe;
PlotLst=SubjInfo.SDGdisplay.PlotLst;
   

if(isempty(AvgData))
    %hard code for now
   
    numMeas=size(SD.MeasList,1);
    
    for idx=1:size(data,1);
        idx2=mod(idx,numMeas/length(SD.Lambda));
         figure(findobj('tag','RT_averager'));
         hold on;
         if(idx2==0); idx2=numMeas/length(SD.Lambda); end
        h(idx)=plot(0,0,'color',SD.Colors(idx2,:),'visible','off'); 
    end
    set(findobj('tag','RT_averager'),'userdata',h);
    
    AvgData.nHRF=15;
    nmeas=size(data,1);
    AvgData.count=ones(AvgData.nHRF,1);
    AvgData.stimback=[];
    AvgData.numstim=0;
    AvgData.data=zeros(nmeas,AvgData.nHRF);
    AvgData.stpt=[];
end


h=get(findobj('tag','RT_averager'),'userdata');
if((time(end)-stim(end)<.5))
    if(length(AvgData.stpt)==0 || (stim(end)-AvgData.stpt(end)>3))
        AvgData.stimback=[AvgData.stimback 1];
        AvgData.numstim=AvgData.numstim+1;
        AvgData.stpt=[AvgData.stpt; stim(end)];
    end
end

stimcurrent=find(AvgData.stimback<=AvgData.nHRF);

lst=AvgData.stimback(stimcurrent);
if(~isempty(lst))
    
    AvgData.data(:,lst)=(AvgData.count(lst).*data)*...
        ones(1,length(stimcurrent));
    AvgData.count(lst)=AvgData.count(lst)+1;
    AvgData.data(:,lst)=AvgData.data(:,lst)./AvgData.count(lst);
    AvgData.stimback=AvgData.stimback+1;

     for idx=1:size(data,1);
         set(h(idx),'XData',[1:length(AvgData.data(idx,:))],'Ydata',AvgData.data(idx,:));
         if(~isempty(find(PlotLst==idx)))
             set(h(idx),'visible','on');
         else
             set(h(idx),'visible','off');
         end
         
     end    
    drawnow
end

return
