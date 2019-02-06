function plotImages(called_from_child)

handles=guihandles(findobj('tag','GSSM_Figure'));
GSSM_data=get(handles.GSSM_Figure,'Userdata');
SD=GSSM_data.SD;
Medium=GSSM_data.Medium;


if(~exist('called_from_child'))
    called_from_child=0;
end

time=GSSM_data.time;

if(isempty(time))

    im=-GSSM_data.Ainv*zeros(size(GSSM_data.Ainv,2),1);
    lmax=.1;
    lmin=-.1;
    HbO=reshape(im(1:end/2),length(GSSM_data.Medium.CompVol.X),length(GSSM_data.Medium.CompVol.Y));
    axes(handles.ImageHbR);
    hold on;
    cla;
    axis xy
    imagesc(Medium.CompVol.X, Medium.CompVol.Y,HbO,[lmin lmax]);
    axis off;
    for idxS=1:size(SD.SrcPos,1)
        t=text( SD.SrcPos(idxS,1), SD.SrcPos(idxS,2), sprintf('x%d', idxS) );
        set(t,'FontSize',12);
    end
    for idxD=1:size(SD.DetPos,1)
        t=text( SD.DetPos(idxD,1), SD.DetPos(idxD,2), sprintf('o%d', idxD) );
         set(t,'FontSize',12);
    end
    axes(handles.ImageHbO);
    hold on;
    cla
    axis xy
    imagesc(Medium.CompVol.X, Medium.CompVol.Y,HbO,[lmin lmax]);
    axis off;
    for idxS=1:size(SD.SrcPos,1)
        t=text( SD.SrcPos(idxS,1), SD.SrcPos(idxS,2), sprintf('x%d', idxS) );
         set(t,'FontSize',12);
    end
    for idxD=1:size(SD.DetPos,1)
        t=text( SD.DetPos(idxD,1), SD.DetPos(idxD,2), sprintf('o%d', idxD) );
         set(t,'FontSize',12);
    end
    return;
end

if(isempty(GSSM_data.stim))
    return
end

numberstim=str2num(get(handles.NumberStim,'string'));
dt=2;
if(length(GSSM_data.stim)>1)
    lststim=find(diff([0 GSSM_data.stim])>dt);
    if(length(lststim)>numberstim)
        lst2=find(GSSM_data.stim >= GSSM_data.stim(lststim(end-numberstim+1)));
    else
        lst2=find(GSSM_data.stim >= GSSM_data.stim(lststim(1)));
    end
else
    lststim=1;
    lst2=1;
end
lst=find(time>=min(GSSM_data.stim(lst2)) & time<=max(GSSM_data.stim(lst2)+10));

if(time(end)>GSSM_data.stim(end)+10 & ~called_from_child)
    return
end
if(isempty(lst) & ~called_from_child)
    return;
end

dspchoice=get(handles.WhichDisplay,'value');
if(dspchoice==1)
    data=GSSM_data.data;
elseif(dspchoice==2)
    data=GSSM_data.beta;
else
    data=GSSM_data.Ttest;
end


data=mean(data(:,lst),2);


im=real(-GSSM_data.Ainv*data);

lmax=max(abs(im(:)));
lmin=-lmax;

HbO=reshape(im(1:end/2),length(GSSM_data.Medium.CompVol.X),length(GSSM_data.Medium.CompVol.Y));
HbR=reshape(im(end/2+1:end),length(GSSM_data.Medium.CompVol.X),length(GSSM_data.Medium.CompVol.Y));

c=get(handles.ImageHbO,'children');
set(c(end),'CData',HbO);
caxis(handles.ImageHbO,[lmin lmax]);

c=get(handles.ImageHbR,'children');
set(c(end),'CData',HbR)
caxis(handles.ImageHbR,[lmin lmax]);

if(get(handles.SendToRemote,'value')==1 & ~called_from_child)
   data=GSSM_data.data(:,end);
   beta=GSSM_data.beta(:,end);
   sendremote(data,beta,length(lststim),time(end),get(handles.RemoteFolderName,'string'));
end

return