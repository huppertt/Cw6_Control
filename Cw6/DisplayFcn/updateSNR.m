function updateSNR(SNR)

try
handles=guihandles(findobj('tag','cw6figure'));
Cw6_data = get(handles.cw6figure,'UserData');


SubjInfo=get(handles.RegistrationInfo,'UserData');
SD=SubjInfo.Probe;

Javahandles=get(findobj('tag','DetTabContainer'),'UserData');

if(~exist('SNR'))

    t=Cw6_data.data.raw_t;
    lst2=find(t>t(end)-5);

%     fs=1/mean(diff(t));
% 
%     [fa,fb]=butter(1,[.3]*2/fs);
%     [fa2,fb2]=butter(1,[1.5]*2/fs);
% 
     d=Cw6_data.data.raw(:,lst2);
% 
%     d_phys=filtfilt(fa,fb,d);
%     d_noise=filtfilt(fa2,fb2,d);
%     SNRall=var(d_phys,[],2)./var(d_noise,[],2);
 fs=1/mean(diff(t));
[fa,fb]=butter(2,[.6]*2/fs);
[fa2,fb2]=butter(2,[1.5]*2/fs,'high');


% [fa,fb]=butter(4,[.6 1.5]*2/fs);
% [fa2,fb2]=butter(4,[1.5]*2/fs,'high');
% [fa,fb]=butter(1,[.8 1.2]*2/fs);
% [fa2,fb2]=butter(1,[1.2 1.6]*2/fs);
d_phys=filtfilt(fa,fb,d')';
d_noise=filtfilt(fa2,fb2,d')';
SNRall=mean(d_phys,2)./std(d_noise,[],2);
   % SNRALL=mean(d,2)./std(d,[],2);
    SNR=ones(SD.NumDet,1);
    for det=1:SD.NumDet
        lst=find(SD.MeasList(:,2)==det);
        if(~isempty(lst))
            SNR(det)= mean(SNRall(lst)); %mean(mean(d,2)./std(d,[],2));
        end
    end
    SNR=10*log10(SNR);
end


for det=1:SD.NumDet
    
    if(SNR(det)<10)
        c=[1 0 0];
    elseif(SNR(det)<20)
        c=[.8 .2 0];
    elseif(SNR(det)<30)
        c=[.4 .6 0];
    else
        c=[0 1 0];
    end
    
    id2=ceil(det/8);
    id=det-8*(id2-1);
    set(Javahandles.LED(id2,id),'Backgroundcolor',c);
end

end
return