
function addData_gssmGUI(data,beta,Ttest,time,stim)

handles=guihandles(findobj('tag','GSSM_Figure'));
GSSM_data=get(handles.GSSM_Figure,'Userdata');

GSSM_data.data=[GSSM_data.data data];
GSSM_data.beta=[GSSM_data.beta beta];
GSSM_data.Ttest=[GSSM_data.Ttest Ttest];
GSSM_data.time=[GSSM_data.time time];
GSSM_data.stim=stim;
set(handles.GSSM_Figure,'Userdata',GSSM_data);
plot_GSSM_main;