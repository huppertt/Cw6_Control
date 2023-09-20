function [d,t]=nirsgetdata(nirs,nsamples)

samplerate=nirs.rate;
%upS=floor(25/samplerate);
upS=200/samplerate;

if(nirs.FirstDataFlag == 0)
    [d,t]=getdata_first(nirs,nsamples*upS*2);            % Manage startup skewing
    l=size(d,1)-nsamples*upS+1;
    l=max(l,1);
%     d=d(l:end,:);
%     t=t(l:end);
    nirs.FirstDataFlag=true;
else
    [d,t]=getdata_more(nirs,nsamples*upS*2);             % Pack, assuming skew handled
end;    

%[fa,fb]=butter(4,1/upS);
%d=decimate(filtfilt(fa,fb,d),1,upS)';
d=resample(d,1,upS)';
%d=d(1:upS:end,:)';
%d=abs(d');
%d=d';
t=t(1:upS:end)';
%d=d';
%t=t';
%t=t';
%Add the "aux" channels
d(end+1:end+6,:)=0;
d=d*100;  %This scale doesn't matter, but it will be on the same magnitude as the Cw6 system.

return


%%
function [d,t]=getdata_first(nirs,nsamples)

nAvailable = get(nirs.ai1,'SamplesAvailable');   % DAQ request data from Engine
if(nsamples>nAvailable)   % need at least 4 to handle skewing cases  
    return;
end
 
%For the first sample, lets grab as much data as we can 


[y_temp, x_temp] = getdata(nirs.ai1,nsamples);          % time-value pairs y is MxN, x is Mx1

P = mean(sign(y_temp(1:2:end,:)),1);  % Column-wise summation of channels 1 through 8
P2 = mean(sign(y_temp(2:2:end,:)),1);  % Column-wise summation of channels 1 through 8
P(5)=0;
if(mean(P)-mean(P2)<0)
    [y_temp2, x_temp2] = getdata(nirs.ai1,1);      % get more data from engine, should be available
    x_temp = [x_temp(2:end,:); x_temp2];                        % remove 1st rows, and append    
    y_temp = [y_temp(2:end,:); y_temp2];   % remove 1st rows, and append    
    clear x_temp2 y_temp2
end;


if(nirs.nBoards>1)
    [y_temp2, x_temp2] = getdata(nirs.ai2,nsamples);          % time-value pairs y is MxN, x is Mx1

    P = mean(sign(y_temp2(1:2:end,:)),1);  % Column-wise summation of channels 1 through 8
    P2 = mean(sign(y_temp2(2:2:end,:)),1);  % Column-wise summation of channels 1 through 8

    if(mean(P-P2)<0)
        [y_temp3, x_temp3] = getdata(nirs.ai1,1);      % get more data from engine, should be available
        x_temp2 = [x_temp2(2:end,:); x_temp3];                        % remove 1st rows, and append
        y_temp2 = [y_temp2(2:end,:); y_temp3];   % remove 1st rows, and append
        clear x_temp2 y_temp2
    end;
else
    y_temp2=[];
end

t=x_temp(1:2:end);
if(isempty(y_temp2))
    d=[y_temp(1:2:end,:) -y_temp(2:2:end,:)];
else
    d=[y_temp(1:2:end,:) -y_temp(1:2:end,:) y_temp2(1:2:end,:) -y_temp2(2:2:end,:)];
end


function [d,t]=getdata_more(nirs,nsamples)

nAvailable = get(nirs.ai1,'SamplesAvailable');   % DAQ request data from Engine
if(nsamples>nAvailable)   % need at least 4 to handle skewing cases  
    return;
end
 
[y_temp, x_temp] = getdata(nirs.ai1,nsamples);          % time-value pairs y is MxN, x is Mx1

if(nirs.nBoards>1)
    [y_temp2, x_temp2] = getdata(nirs.ai2,nsamples);          % time-value pairs y is MxN, x is Mx1
else
    y_temp2=[];
end

t=x_temp(1:2:end);
if(isempty(y_temp2))
    d=[y_temp(1:2:end,:) -y_temp(2:2:end,:)];
else
    d=[y_temp(1:2:end,:) -y_temp(1:2:end,:) y_temp2(1:2:end,:) -y_temp2(2:2:end,:)];
end


