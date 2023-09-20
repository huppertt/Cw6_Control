function [d,t]=getsamples(foo,numbersamples);
global Cw6device;

try
    maxAux=getNumAux(Cw6device.instrument);
catch
    maxAux=4;
end

numbersamples=max([numbersamples 0]);
d=zeros((Cw6device.samplechannels+2+maxAux)*numbersamples,1);
% 
% %read to the first header
% cnt=0;
% if(1) %Cw6device.lastcalled==0)
% while(1)
%     d(1)=Cw6device.instrument.GetData(1);
%     if(d(1)==-999 | d(1)==9999 | d(1)<.1)
%         break;
%     end
%     cnt=cnt+1;
% end
%     if(cnt>0)
%          disp(['Warning: Unexpected data shift: ' num2str(cnt) ' data points']); 
%         numbersamples=numbersamples-1;
%     end
% end
% 
% if(numbersamples==0)
%     d=[];
%     t=[];
%     return
% end


for samples=1:numbersamples*(Cw6device.samplechannels+2+maxAux)
    d(samples)=Cw6device.instrument.GetData(1);
end
d=reshape(d,(Cw6device.samplechannels+2+maxAux),numbersamples);

if(d(end)~=-999)
    d=[];
    t=[];
    disp(['error in bit registry @ ' num2str(toc) 's']);
    return
end


t=[Cw6device.lastcalled:Cw6device.lastcalled+numbersamples-1]./Cw6device.instrument.GetDataRate;
Cw6device.lastcalled=Cw6device.lastcalled+numbersamples;

return