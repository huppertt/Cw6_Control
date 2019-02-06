function AutoAdjustGain(varargin)


handles=guihandles(findobj('tag','cw6figure'));
system=get(handles.AquistionButtons,'Userdata');
Javahandles=get(findobj('tag','DetTabContainer'),'UserData');

if(~any(getlaser(system.MainDevice)))
    warndlg('At Least One Laser Must Be On');
    return
end

h=waitbar(0,'Adjusting AGC');


%[numTabs,numDet]=size(Javahandles.spinner);
numTabs=4;
numDet=8;


SubjInfo=get(handles.RegistrationInfo,'UserData');
SD=SubjInfo.Probe;

adjusting=true;
maxTime=20;
tic;
while(adjusting)
    
    Te=toc;
    h=waitbar(Te/maxTime,h);
    if(Te>maxTime)
        break;
    end
gainchanges=getgainstep(Javahandles.spinner,system,SD);    
istop=zeros(SD.NumDet,1);
if(sum(gainchanges)==0)
    adjusting=false;
    break;
end
    
for Tab=1:numTabs
    for Det=1:numDet
        DetIdx=Det+numDet*(Tab-1);
        if(~isempty(find(SD.MeasList(:,2)==DetIdx)) & get(Javahandles.spinner(Tab,Det),'enabled')==1)
            val=get(Javahandles.spinner(Tab,Det),'Value');
            set(Javahandles.spinner(Tab,Det),'Value',val+gainchanges(DetIdx));
            if(val>=100)
                istop(DetIdx)=1;
            end
        else
            set(Javahandles.spinner(Tab,Det),'Value',0);
        end
    end
end

if(all(istop==1))
    break;
end

end

for Tab=1:numTabs
    for Det=1:numDet
        DetIdx=Det+numDet*(Tab-1);
        system.AQSettings.Gains(DetIdx)=get(Javahandles.spinner(Tab,Det),'Value');
    end
end
try
    close(h);
end


%Update the TDM
SubjInfo=get(handles.RegistrationInfo,'UserData');
     
if(~isfield(system,'AQSettings'))
        system.AQSettings.Lasers=zeros(NUM_SRC,1);
elseif(~isfield(system.AQSettings,'Lasers'))
        system.AQSettings.Lasers=zeros(NUM_SRC,1);
end
    

Gains=system.AQSettings.Gains;

if(isfield(system,'TDMSettings') && isfield(system.TDMSettings,'StateSelected'))

    state=system.TDMSettings.StateSelected;
    mlState=find(SubjInfo.Probe.MeasList(:,5)==state);
    SrcLst=unique(SubjInfo.Probe.MeasList(mlState,1));
    DetLst=unique(SubjInfo.Probe.MeasList(mlState,2));

    LaserLst=SubjInfo.Probe.LaserPos(SrcLst(:),:);
    system.TDMSettings.LasersOn(LaserLst(:),state)=system.AQSettings.Lasers(LaserLst(:));
    system.TDMSettings.DetGains(DetLst,state)=Gains(DetLst);
    set(handles.AquistionButtons,'Userdata',system);
    updateCw6DeviceTDM;
end

return

function gainchanges=getgainstep(spinners,system,SD)
warning('off','all');
persistent SNR;
persistent LASETGAINCHANGE;

datarate=getdatarate(system.MainDevice);
try
setdatarate(system.MainDevice,20);

gainchanges=zeros(SD.NumDet,1);

if(isempty(SNR))
    SNR=zeros(SD.NumDet,1);
    LASETGAINCHANGE=35*ones(SD.NumDet,1);
end

start(system.MainDevice);
pause(1);
stop(system.MainDevice);
[d,t]=getsamples(system.MainDevice,min(samplesavaliable(system.MainDevice),10));

%SNR_raw=mean(d(1:end-5,:),2)./std(d(1:end-5,:),[],2);
% [fa,fb]=butter(4,[.1 1.4]*2/10);
% [fa2,fb2]=butter(4,[3]*2/10,'high');
%  fs=1/mean(diff(t));
% 
% % [fa,fb]=butter(4,[.6 1.5]*2/fs);
% % [fa2,fb2]=butter(4,[1.5]*2/fs,'high');
% % [fa,fb]=butter(1,[.8 1.2]*2/fs);
% % [fa2,fb2]=butter(1,[1.2 1.6]*2/fs);
% d_phys=filtfilt(fa,fb,d(1:end-5,:));
% d_noise=filtfilt(fa2,fb2,d(1:end-5,:));
% 
% SNR_raw=var(d_phys,[],2)./var(d_noise,[],2);

if(isempty(t))
    return;
end
fs=1/mean(diff(t));
[fa,fb]=butter(2,[ .6]*2/fs);
[fa2,fb2]=butter(2,[1.5]*2/fs,'high');

SD.MeasList=unique(SD.MeasList(:,[1:4]),'rows');

% [fa,fb]=butter(4,[.6 1.5]*2/fs);
% [fa2,fb2]=butter(4,[1.5]*2/fs,'high');
% [fa,fb]=butter(1,[.8 1.2]*2/fs);
% [fa2,fb2]=butter(1,[1.2 1.6]*2/fs);
d_phys=filtfilt(fa,fb,d);
d_noise=filtfilt(fa2,fb2,d);
SNR_raw=mean(d_phys,2)./std(d_noise,[],2);

SNR_det=zeros(size(SD.MeasList,1),1);
for dIdx=1:SD.NumDet
    lst=find(SD.MeasList(:,2)==dIdx);
    SNR_det(dIdx)=mean(SNR_raw(lst));
end

try
    dSNR=SNR_det-SNR;
catch
     SNR=zeros(SD.NumDet,1);
     dSNR=SNR_det;
end

LASETGAINCHANGE=abs(LASETGAINCHANGE);

lstgood=find(dSNR>0);
gainchanges(lstgood)=LASETGAINCHANGE(lstgood);
lstbad=find(dSNR<0);
gainchanges(lstbad)=-.5*LASETGAINCHANGE(lstbad);

gainchanges=round(gainchanges);

LASETGAINCHANGE=gainchanges;
SNR=SNR_det;

updateSNR;
end
 setdatarate(system.MainDevice,datarate);

return