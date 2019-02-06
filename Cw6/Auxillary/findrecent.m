function file=findrecent(folder,ext,maxRecursion)

mostrecent=0;
if(~exist('maxRecursion'))
    maxRecursion=2;
end

files=dir(folder);
file=[];
persistent recursion;
if(isempty(recursion))
    recursion=1;
end
maxtime=now;

for idx=1:length(files)
    if(~files(idx).isdir)
        flag=0;
        for extE=1:length(ext)
            if(~isempty(strfind(files(idx).name,ext{extE})))
                flag=1;
                break;
            end
        end
        if(flag & datenum(files(idx).date)>mostrecent & datenum(files(idx).date)<maxtime)
            mostrecent=datenum(files(idx).date);
            file=files(idx);
            file.name=[folder filesep file.name];
        end
    else
        if(~strcmp(files(idx).name,'.') & ~strcmp(files(idx).name,'..') & recursion<maxRecursion);
        recursion=recursion+1;
        temp=findrecent([folder filesep files(idx).name],ext);
        recursion=recursion-1;
        if(~isempty(temp) & datenum(temp.date)>mostrecent & datenum(temp.date)<maxtime)
            mostrecent=datenum(temp.date);
            file=temp;
        end
        end
    end
end
    
        