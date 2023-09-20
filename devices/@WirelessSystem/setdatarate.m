function  setdatarate(foo,rate)
global NIRS2device;
% 
% if(rate==50)
%     sendcmd(nirs,'f50');
% else
%     sendcmd(nirs,'f75');
% end

rate=75/floor(75/rate);
disp(['Setting rate to ' num2str(rate)]);

NIRS2device.SystemInfo.rate=rate;

return