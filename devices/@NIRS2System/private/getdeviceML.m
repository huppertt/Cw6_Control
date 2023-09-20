function ML=getdeviceML
%Default for ML from this device;

global NUM_SRC;
global NUM_DET;

ML=zeros(NUM_SRC*NUM_DET,4);
cnt=1;
for idx=1:NUM_SRC
    for idx2=[1 2 3 4]
        ML(cnt,2)=idx2;
        ML(cnt,1)=idx;
        ML(cnt,4)=mod(idx,2);
        cnt=cnt+1;
    end
end

return