function [A, Medium]=makefwdModel(SD)


SD.SrcAmp = ones(size(SD.SrcPos,1));
SD.DetAmp = ones(size(SD.DetPos,1));

%put into new SD.ML format by filling in the missing fields
if size(SD.MeasList,2)~=7
    SD.MeasList(:,size(SD.MeasList,2)+1:7)=0;
end

if ~isfield(SD,'ModFreq')
    SD.ModFreq = 0;
end


nLambda = length(SD.Lambda);

Medium.idxRefr  = 1.37 * ones(1,nLambda);
Medium.Muao     = 10 * ones(1,nLambda);
Medium.Muso     = .1 * ones(1,nLambda);
Medium.g        = 0 * ones(1,nLambda);
Medium.Muspo    = Medium.Muso;
Medium.v        = 218978102.2 * ones(1,nLambda);
Medium.Geometry = 'semi';

Medium.CompVol.Type  = 'uniform';

xmin = min( [SD.SrcPos(:,1); SD.DetPos(:,1)] );
xmax = max( [SD.SrcPos(:,1); SD.DetPos(:,1)] );
ymin = min( [SD.SrcPos(:,2); SD.DetPos(:,2)] );
ymax = max( [SD.SrcPos(:,2); SD.DetPos(:,2)] );

ystep=(ymax-ymin)/20;
xstep=(xmax-xmin)/20;

Medium.CompVol.X     = xmin:xstep:xmax;
Medium.CompVol.XStep = xstep;
Medium.CompVol.Y     = ymin:ystep:ymax; 
Medium.CompVol.YStep = ystep;
Medium.CompVol.Z     = 2;
Medium.CompVol.ZStep = 1;

Medium.Slab_Thickness=10;

[Phi0, A] = genBornMat(SD, Medium, [], 'Rytov', [1 0]);


nVox=size(A,2);


A2=zeros(size(A,1),nVox*nLambda);


for idxLambda=1:nLambda
    lst=find(SD.MeasList(:,4)==idxLambda);
    A2(lst,[nVox*(idxLambda-1)+1:idxLambda*nVox])=A(lst,:);
end
A=A2;

return