function ML=getdeviceML
%Default for ML from this device;

global NUM_SRC;
global NUM_DET;

ML(1,:)=[1 1 0 1];  % A1 @690
ML(2,:)=[5 4 0 1];  % C4 @690
ML(3,:)=[2 1 0 2];  % A1 @830
ML(4,:)=[6 4 0 2];  % C4 @830
ML(5,:)=[3 2 0 1];  % B2 @690
ML(6,:)=[7 5 0 1];  % D5 @690
ML(7,:)=[4 2 0 2];  % B2 @830
ML(8,:)=[8 5 0 2];  % D5 @830
ML(9,:)=[1 2 0 1];  % A2 @690
ML(10,:)=[5 5 0 1]; % C5 @690
ML(11,:)=[2 2 0 2]; % A2 @830
ML(12,:)=[6 5 0 2]; % C5 @830
ML(13,:)=[3 3 0 1]; % B3 @690
ML(14,:)=[7 6 0 1]; % D6 @690
ML(15,:)=[4 3 0 2]; % B3 @830
ML(16,:)=[8 6 0 2]; % D6 @830
% 
% 
% ML=zeros(NUM_SRC*NUM_DET,4);
% cnt=1;
% for idx=1:NUM_SRC
%     for idx2=[1 2 3 4]
%         ML(cnt,2)=idx2;
%         ML(cnt,1)=idx;
%         ML(cnt,4)=mod(idx,2);
%         cnt=cnt+1;
%     end
% end

return

% 
% A1 @690nm
% C4 @690nm
% A1 @830nm
% C4 @830nm
% B2 @690nm
% D5 @690nm
% B2 @830nm
% D5 @830nm
% 
% A2 @690nm
% C5 @690nm
% A2 @830nm
% C5 @830nm
% B3 @690nm
% D6 @690nm
% B3 @830nm
% D6 @830nm
