function [GSS_model,handles,iH]=init_gssm_imagerecon
%This function generates the gssm_GLM structure

try
    handles=guihandles(findobj('tag','cw6figure'));
    SubjInfo=get(handles.RegistrationInfo,'UserData');
%   SD=SubjInfo.Probe;   
%    system=get(handles.AquistionButtons,'Userdata');
end

%Load the image reconstruction basis
disp('Loading sample brain');
load('SampleBrain.mat');

c='w';

f=BrainDisplay;
handles=guihandles(f);
set(handles.axes_plotbrainL,'color',c)
set(handles.axes_plotbrainR,'color',c)
set(handles.axes5,'color',c)
set(handles.axes_plotbrainL,'XColor',c)
set(handles.axes_plotbrainL,'YColor',c)
set(handles.axes_plotbrainL,'ZColor',c)
set(handles.axes_plotbrainR,'XColor',c)
set(handles.axes_plotbrainR,'YColor',c)
set(handles.axes_plotbrainR,'ZColor',c)
set(handles.axes5,'XColor',c)
set(handles.axes5,'YColor',c)
set(handles.axes5,'ZColor',c)

handles.brainL=plot_brain(Pialsurf.vertices',Pialsurf.faces',handles.axes_plotbrainL);
view(handles.axes_plotbrainL,90,0)
LL=light('parent',handles.axes_plotbrainL);
set(LL,'position',[-100 100 0])

handles.brainR=plot_brain(Pialsurf.vertices',Pialsurf.faces',handles.axes_plotbrainR);
view(handles.axes_plotbrainR,-90,0)
LR=light('parent',handles.axes_plotbrainR);
set(LR,'position',[-100 -100 0]);

caxis(handles.axes_plotbrainL,[-1 1]);
caxis(handles.axes_plotbrainR,[-1 1]);

%Now, load the forward model
disp('Loading forward model...');
load('BALT_fwd.mat');

H = L*1E3;
[U,S,V]=mysvd(H);

% Y = U*S*V'*Beta
iH = blkdiag(inv_WLMtx,inv_WLMtx)*V;

%For HbO only
iH = iH(2051:end/2,:);

H=cat(1,U*S,speye(size(U,2)));

GSS_model.model= gssm_recon('init',H);

%Estimation
Arg.type = 'state';                                 % inference type (state estimation)
Arg.tag = 'State estimation for GLM system.';       % arbitrary ID tag
Arg.model = GSS_model.model;                                % GSSM data structure of external system
GSS_model.InfDS = geninfds(Arg);                               % Create inference data structure and
[GSS_model.pNoise, GSS_model.oNoise, GSS_model.InfDS] = gensysnoiseds(GSS_model.InfDS, 'kf');       % generate process and observation noise sources
