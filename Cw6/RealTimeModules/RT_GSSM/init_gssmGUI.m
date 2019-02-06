function init_gssmGUI(SD)

%Initialize all the image reconstruction code:

[A, Medium]=makefwdModel(SD);

%s= diag(1./sum(A,1));
Ainv=full(A');

GSSM_data.Ainv=Ainv;
GSSM_data.Medium=Medium;
GSSM_data.SD=SD;
GSSM_data.data=[];
GSSM_data.beta=[];
GSSM_data.time=NaN;
GSSM_data.stim=[];

hObject=Plot_GSSM;
set(hObject,'UserData',GSSM_data);

plot_GSSM_SDG;

GSSM_data.time=[];
set(hObject,'UserData',GSSM_data);

RemoteFolderName=findobj('tag','RemoteFolderName');
set(RemoteFolderName,'string','D:/CW6/RemoteConnect/Data.txt');