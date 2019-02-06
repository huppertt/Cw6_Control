function loadpreviousdata(filename)

load(filename);

handles=guihandles(findobj('tag','cw6figure'));
set(handles.cw6figure,'UserData',Cw6_data);
Cw6LoadSubjInfo(SubjInfo);

if isfield(Cw6_data,'RTmodules')
h=waitbar(0,'Proccesing Real-time');
    

%handles=guihandles(findobj('tag','GSSM_Figure'));
%mov = avifile('RealTimeTapping.avi','Compression','none')

processRTfunctions([],[],[],[]);
for idx=1:length(Cw6_data.data.raw_t)
    h=waitbar(idx/length(Cw6_data.data.raw_t),h,'Proccesing Real-time');
    stim={};
    for j=1:length(Cw6_data.data.stim)
        stim{j}=Cw6_data.data.stim{j}(find(Cw6_data.data.stim{j}<=Cw6_data.data.raw_t(idx)));
    end
    processRTfunctions(Cw6_data.data.raw_t(idx),Cw6_data.data.raw(:,idx),Cw6_data.data.aux(:,idx),stim);
  %F = getframe(handles.GSSM_Figure);
 %mov = addframe(mov,F);
end
close(h);
%mov = close(mov);
end
