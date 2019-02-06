function stim=catchstim(stim,auxdata,time)

persistent meanstimchan;
persistent MSEstimchan;
persistent count;

if(isempty(auxdata))
    meanstimchan=zeros(5,1);;
    MSEstimchan=0;
    count=ones(5,1);
    return
end

stiminfo=get(findobj('tag','setup_stim'),'Userdata');
if(isempty(stiminfo) | ~isfield(stiminfo,'usestim'))
    stiminfo.usestim=1;
end

% if(size(auxdata,1)==1 & size(auxdata,2)~=6)
%     auxdata=auxdata';
% end;


auxdata=abs(auxdata);
global SYSTEM_TYPE;
if(strcmp(SYSTEM_TYPE,'NIRS2'))
    auxdata=auxdata';
    for idx=1:length(stiminfo.usestim)
        stimchannel=auxdata(stiminfo.usestim(idx),:);
        
        lst=find(abs(stimchannel-meanstimchan(idx))>1);  %1Volt change
        if(~isempty(lst) & time(1)>3)
            if(~isempty(stim{idx}))
                if(time-stim{idx}(end)>3)
                    NumberStimuliText=findobj('tag','NumberStimuliText');
                    numStim=str2num(get(NumberStimuliText,'string'));
                    set(NumberStimuliText,'string',num2str(numStim+1));
                end
            else
                NumberStimuliText=findobj('tag','NumberStimuliText');
                numStim=str2num(get(NumberStimuliText,'string'));
                set(NumberStimuliText,'string',num2str(numStim+1));
            end
            if(size(time(lst),2)>1), time=time'; end
            stim{idx}=[stim{idx} time(lst)'];
        else
            meanstimchan(idx)=(meanstimchan(idx)*count(idx)+sum(stimchannel))/(count(idx)+size(auxdata,2));
            count(idx)=count(idx)+size(auxdata,2);
        end
    end
    
else
     %  auxdata=auxdata';
    for idx=1:length(stiminfo.usestim)
        stimchannel=auxdata(stiminfo.usestim(idx),:);
        auxdata=auxdata';
        lst=find(abs(stimchannel-meanstimchan(idx))>5E3);  %1Volt change
        if(~isempty(lst) & time(1)>3)
            if(~isempty(stim{idx}))
                if(time-stim{idx}(end)>3)
                    NumberStimuliText=findobj('tag','NumberStimuliText');
                    numStim=str2num(get(NumberStimuliText,'string'));
                    set(NumberStimuliText,'string',num2str(numStim+1));
                end
            else
                NumberStimuliText=findobj('tag','NumberStimuliText');
                numStim=str2num(get(NumberStimuliText,'string'));
                set(NumberStimuliText,'string',num2str(numStim+1));
            end
            
            stim{idx}=[stim{idx} time];
        else
            meanstimchan(idx)=(meanstimchan(idx)*count(idx)+sum(stimchannel))/(count(idx)+size(auxdata,2));
            count(idx)=count(idx)+size(auxdata,2);
        end
    end
% 
%     for idx=1:length(stiminfo.usestim)
%         stimchannel=auxdata(stiminfo.usestim(idx),:);
% 
%         lst=find(abs(stimchannel-meanstimchan)>120*sqrt(MSEstimchan)/count(idx));
%         if(~isempty(lst) & time(1)>3)
%             if(~isempty(stim{idx}))
%                 if(time-stim{idx}(end)>3)
%                     NumberStimuliText=findobj('tag','NumberStimuliText');
%                     numStim=str2num(get(NumberStimuliText,'string'));
%                     set(NumberStimuliText,'string',num2str(numStim+1));
%                 end
%             else
%                 NumberStimuliText=findobj('tag','NumberStimuliText');
%                 numStim=str2num(get(NumberStimuliText,'string'));
%                 set(NumberStimuliText,'string',num2str(numStim+1));
%             end
%             if(size(time(lst),2)>1), time=time'; end
%             stim{idx}=[stim{idx} time(lst)'];
%         else
%             meanstimchan=(meanstimchan*count(idx)+sum(stimchannel))/(count(idx)+size(auxdata,2));
%             % disp(meanstimchan)
%             MSEstimchan=(MSEstimchan+(mean(stimchannel)-meanstimchan)^2);
%             %disp(sqrt(MSEstimchan)/count(idx));
%             count(idx)=count(idx)+size(auxdata,2);
%         end
%     end
end
