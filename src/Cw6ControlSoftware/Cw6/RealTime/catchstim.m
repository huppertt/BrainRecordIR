function stim=catchstim(stim,auxdata,time)

persistent meanstimchan;
persistent MSEstimchan;
persistent count;

if(isempty(auxdata))
    meanstimchan=0;
    MSEstimchan=0;
    count=1;
    return
end

stimchannel=auxdata(1,:);

if(abs(stimchannel-meanstimchan)>500*sqrt(MSEstimchan)/count & time>3)
   if(~isempty(stim))
        if(time-stim(end)>3)
            NumberStimuliText=findobj('tag','NumberStimuliText');
            numStim=str2num(get(NumberStimuliText,'string'));
            set(NumberStimuliText,'string',num2str(numStim+1));
        end
    else
        NumberStimuliText=findobj('tag','NumberStimuliText');
        numStim=str2num(get(NumberStimuliText,'string'));
        set(NumberStimuliText,'string',num2str(numStim+1));
    end
    stim=[stim time(end)];
else
    meanstimchan=(meanstimchan*count+stimchannel)/(count+1);
    MSEstimchan=(MSEstimchan+(stimchannel-meanstimchan)^2);
    count=count+1;
end


