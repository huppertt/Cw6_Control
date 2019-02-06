function ShowTDM_SDG(state)

handles=guihandles(findobj('tag','TDM_MenuFigure'));
Cw6handles=guihandles(findobj('tag','cw6figure'));
SubjInfo=get(Cw6handles.RegistrationInfo,'UserData');

axes(handles.TDM_ShowProbe);
cla;
SD=SubjInfo.Probe;
maxX=max([SD.SrcPos(:,1); SD.DetPos(:,1)]);
minX=min([SD.SrcPos(:,1); SD.DetPos(:,1)]);
maxY=max([SD.SrcPos(:,2); SD.DetPos(:,2)]);
minY=min([SD.SrcPos(:,2); SD.DetPos(:,2)]);

rangeX=maxX-minX;
rangeY=maxY-minY;
maxX=maxX+.25*rangeX;
minX=minX-.25*rangeX;
maxY=maxY+.25*rangeY;
minY=minY-.25*rangeY;

numStates=length(unique(SD.MeasList(:,5)));

for idx=1:numStates   
    mlLst=find(SD.MeasList(:,5)==idx);
    for mIdx=1:length(mlLst)
        sI=SD.MeasList(mlLst(mIdx),1);
        dI=SD.MeasList(mlLst(mIdx),2);
        axes(handles.TDM_ShowProbe);
        hL=line([SD.SrcPos(sI,1) SD.DetPos(dI,1)],...
            [SD.SrcPos(sI,2) SD.DetPos(dI,2)],'color','k');
        if(idx==state)
            set(hL,'color',[0 0 0]);
            set(hL,'linewidth',3);
        else
            set(hL,'color',[.4 .4 .4]);
            set(hL,'linewidth',1);
        end
    end
end

for Sidx=1:SD.NumSrc
   axes(handles.TDM_ShowProbe);
    hS(Sidx)=text(SD.SrcPos(Sidx,1),SD.SrcPos(Sidx,2),['S-' num2str(Sidx)],'color','k');
end
for Didx=1:SD.NumDet
    axes(handles.TDM_ShowProbe);
    hD(Didx)=text(SD.DetPos(Didx,1),SD.DetPos(Didx,2),['D-' num2str(Didx)],'color','k');
end

set(hD,'FontWeight','bold')
set(hS,'FontWeight','bold')
axes(handles.TDM_ShowProbe);
axis([minX maxX minY maxY]);

return