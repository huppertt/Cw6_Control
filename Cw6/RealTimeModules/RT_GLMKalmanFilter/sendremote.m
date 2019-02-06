function sendremote(data,beta,stimNum,time,filename)

global remoteChannels;

try
fid=fopen(filename,'a');

fprintf(fid,'\n%f\t%d',time,stimNum);

   for idx=1:length(remoteChannels)
       d=mean(data(remoteChannels{idx}));
       fprintf(fid,'\t%f',d);
   end
   for idx=1:length(remoteChannels)
       d=mean(beta(remoteChannels{idx}));
      
       fprintf(fid,'\t%f',d);
   end
    fclose(fid);
catch
    try
         fclose(fid);
    end
end

return