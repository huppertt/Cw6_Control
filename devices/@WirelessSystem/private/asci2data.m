function d=asci2data(str)

% lst=find(str==double('$'));
% if(length(lst)>0 && lst(1)>1)
%     str(1:lst(1)-1)=[];
% end

ns=85;
cnt=1;
while(length(str)>=ns)
    dtmp=str(1:ns);
    brks=find(dtmp==double(','));
    nchan=length(brks);
    brks=[1; brks];
    for ch=1:nchan
        tmp=dtmp(brks(ch)+1:brks(ch+1)-1);
        d(ch,cnt)=asci2val(vertcat(char(tmp(:))'));
        
        
    end
    cnt=cnt+1;
    str(1:ns)=[];
end

return

function val=asci2val(asci);

asci(find(double(asci)<48 | double(asci)>70))=[];

val=0;
for idx=1:length(asci)
    switch(asci(idx))
        case{'0','1','2','3','4','5','6','7','8','9'}
            n=str2num(asci(idx));
        case('A')
            n=10;
        case('B')
            n=11;
        case('C')
            n=12;
        case('D')
            n=13;
        case('E')
            n=14;
        case('F')
            n=15;           
    end
    val=val+16^(length(asci)-idx)*n;
end

return