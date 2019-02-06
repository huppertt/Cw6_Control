function ShowAux(varargin)

try

handles=guihandles(findobj('tag','cw6figure'));
Cw6_data = get(handles.cw6figure,'UserData');

try
    Cw6_data.data.aux(1);
catch
    
    return;
end
figure;

aux=abs(Cw6_data.data.aux(1:end-1,:));
aux=aux-(mean(aux(:,1:ceil(end/30)),2)*ones(1,size(aux,2)));
aux=aux./max(abs(aux(:)));
t=Cw6_data.data.aux_t;
% stim=-2*ones(size(t));
% for idx=1:length(Cw6_data.data.stim)
%     lst=find(t>=Cw6_data.data.stim(idx) & t<.1+Cw6_data.data.stim(idx));
%     stim(lst)=2;
% end
  if(isfield(Cw6_data.data,'stim'))
        s=zeros(length(t),0);
        for chan=1:length(Cw6_data.data.stim)
            flag=false;
        for idx=1:length(Cw6_data.data.stim{chan})
            [foo,id]=min(abs(t-Cw6_data.data.stim{chan}(idx)));
            if(flag)
                s(id,end)=1;
            else
                flag=true;
                s(id,end+1)=1;
            end
        end
        end
    else
        s=zeros(length(t),1);
  end
    if(size(s,2)~=0)
        
h=plot(t,4*s-2);
hold on;
    end
plot(t,aux');
str={};
for idx=1:size(s,2)
    str{idx}=['Stim Channel-' num2str(idx)];
end
for idx=1:size(aux,1)
    str{end+1}=['Aux-' num2str(idx)];
end

try; set(h(1),'color','g'); end;
axis([t(1) t(end) -.5 1.3]);
legend(str);

end
return