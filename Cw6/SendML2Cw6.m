function DataToMLMap=SendML2Cw6(ml_probe,SD,ml_Device);

global NUM_SRC;
global NUM_DET;
figurehandle=findobj('tag','cw6figure');
AquistionButtons=findobj('tag','AquistionButtons');
system=get(AquistionButtons,'Userdata');

states=zeros(size(ml_Device,1),1);

DataToMLMap=zeros(size(ml_probe,1),1);

mlMap=SD.mlMap;

for idx=1:length(mlMap)
    states(mlMap(idx))=1;
end

cnt=0;
for idx=1:length(states);
    setML(system.MainDevice,idx,states(idx));
end

lst=find(states==1);

if(isa(type(system.MainDevice),'CW6System') | isa(type(system.MainDevice),'CW6MINISystem'))
   global Cw6device;
   frqmap=Cw6device.SystemInfo.frqMap;


    ml=[]; cnt=0;
    for Didx=1:32
        for Sidx=1:length(frqmap)
            Lidx=find(frqmap==Sidx);
            if(~isempty(Lidx))
                thispoint=find(ismember(ml_Device(lst,2),Didx) & ismember(ml_Device(lst,1),Lidx));
                if(~isempty(thispoint))
                    cnt=cnt+1;
                    ml=[ml; Lidx Didx Sidx];
                end
            end
        end
        if(~isempty(ml))
        lst2=find(ml(:,2)==Didx);
        ml(lst2,:)=sortrows(ml(lst2,:),3);
        end
    end

    if(isa(type(system.MainDevice),'CW6MINISystem'))
        global numDetrows;
        lst=find(ml_probe(:,2)>2*numDetrows);
        ml_probe(lst,2)=ml_probe(lst,2)+16-2*numDetrows;
        
        lst=find(ml(:,2)>2*numDetrows);
        ml(lst,2)=ml(lst,2)+16-2*numDetrows;
    end
    

    for idx=1:size(ml_probe,1);
        SrcIdx=ml_probe(idx,1);
        DetIdx=ml_probe(idx,2);
        LambdaIdx=ml_probe(idx,4);
        LaserIdx=SD.LaserPos(SrcIdx,LambdaIdx);
        % LaserIdx=find(frqmap==LaserIdx)
        DataToMLMap(idx)=find(ismember(ml(:,1),LaserIdx) & ismember(ml(:,2),DetIdx));
    end
elseif(isa(type(system.MainDevice),'NIRS2System') )
    frqmap=1:NUM_SRC;
    lst=1:length(ml_Device);
    ml=[]; cnt=0;
    dmap=[1 3 2 4 5 6];
    for Sidx=1:length(frqmap)
        for Didx=1:NUM_DET
            Lidx=find(frqmap==Sidx);
            if(~isempty(Lidx))
                thispoint=find(ismember(ml_Device(lst,1),dmap(Didx)) & ismember(ml_Device(lst,2),Lidx));
                if(~isempty(thispoint))
                    cnt=cnt+1;
                    ml=[ml; Lidx dmap(Didx) Sidx];
                end
            end
        end
        lst2=find(ml(:,2)==Didx);
        ml(lst2,:)=sortrows(ml(lst2,:),3);

    end


    for idx=1:size(ml_probe,1);
        SrcIdx=ml_probe(idx,1);
        DetIdx=ml_probe(idx,2);
        LambdaIdx=ml_probe(idx,4);
        LaserIdx=SD.LaserPos(SrcIdx,LambdaIdx);
        % LaserIdx=find(frqmap==LaserIdx)
        DataToMLMap(idx)=find(ismember(ml(:,1),LaserIdx) & ismember(ml(:,2),DetIdx));
    end
elseif(isa(type(system.MainDevice),'WirelessSystem'))

    for idx=1:size(ml_probe,1);
        SrcIdx=ml_probe(idx,1);
        DetIdx=ml_probe(idx,2);
        LambdaIdx=ml_probe(idx,4);
        LaserIdx=SD.LaserPos(SrcIdx,LambdaIdx);
        % LaserIdx=find(frqmap==LaserIdx)
        DataToMLMap(idx)=find(ismember(ml_Device(:,1),LaserIdx) & ismember(ml_Device(:,2),DetIdx));
    end
    
    
    
    
elseif(isa(type(system.MainDevice),'Simulator'))
    
    mldevice=getML(system.MainDevice);
    mldevice=mldevice(find(states),:);
    for idx=1:size(mldevice,1)
        [sIdx,~]=find(SD.LaserPos==mldevice(idx,1));
        mldevice(idx,1)=sIdx;
    end
    
    for idx=1:size(ml_probe,1);
        DataToMLMap(idx)=find(ismember(mldevice(:,[1 2 4]),ml_probe(idx,[1 2 4]),'rows'));
    end
end
return