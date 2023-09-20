function ML=getdeviceML
%Default for ML from this device;

%global NUM_SRC;
%global NUM_DET;

%Overwrite the numbers set for the instrument
NUM_SRC=32;
NUM_DET=32;

ML=zeros(NUM_SRC*NUM_DET,4);
cnt=1;
for idx=1:NUM_DET
    for idx2=1:2:16
        ML(cnt,1)=idx2;
        ML(cnt,2)=idx;
        ML(cnt,4)=mod(idx2,2);
        cnt=cnt+1;
    end
    for idx2=2:2:16
        ML(cnt,1)=idx2;
        ML(cnt,2)=idx;
        ML(cnt,4)=mod(idx2,2);
        cnt=cnt+1;
    end
    for idx2=17:2:NUM_SRC
        ML(cnt,1)=idx2;
        ML(cnt,2)=idx;
        ML(cnt,4)=mod(idx2,2);
        cnt=cnt+1;
    end
    for idx2=18:2:NUM_SRC
        ML(cnt,1)=idx2;
        ML(cnt,2)=idx;
        ML(cnt,4)=mod(idx2,2);
        cnt=cnt+1;
    end    
end

%For the mini system, switch detectors [3,4] to [17,18]
ML2=ML;
ML(find(ML2(:,2)==3),2)=17;
ML(find(ML2(:,2)==4),2)=18;
ML(find(ML2(:,2)==17),2)=3;
ML(find(ML2(:,2)==18),2)=4;



return