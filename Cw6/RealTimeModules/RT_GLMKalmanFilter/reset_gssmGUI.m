function reset_gssmGUI(SD)

global remoteChannels

if(exist('SD'))
    remoteChannels={};
    for idx=1:size(SD.MeasList,1)
        remoteChannels{idx}=idx;
    end
end


handles=guihandles(findobj('tag','GSSM_Figure'));
GSSM_data=get(handles.GSSM_Figure,'Userdata');
GSSM_data.data=[];
GSSM_data.beta=[];
GSSM_data.Ttest=[];
GSSM_data.time=[];
GSSM_data.stim=[];
set(handles.GSSM_Figure,'Userdata',GSSM_data);
plot_GSSM_SDG;


if(get(handles.SendToRemote,'value'))
   filename=get(handles.RemoteFolderName,'string');
   fid=fopen(filename,'w');
     
   fprintf(fid,'Time\tStim#');
   for idx=1:length(remoteChannels)
       fprintf(fid,'\tROI%d_Yhat',idx);
   end
   for idx=1:length(remoteChannels)
       fprintf(fid,'\tROI%d_Beta',idx);
   end
   fclose(fid);
   
   %also save the probe
   if(~exist('SD'))
   handles=guihandles(findobj('tag','GSSM_Figure'));

    GSSM_data=get(handles.GSSM_Figure,'Userdata');
    SD=GSSM_data.SD;
    end
   filename=strtok(filename,'.');
   save([filename '.sd'],'SD','-MAT');
end