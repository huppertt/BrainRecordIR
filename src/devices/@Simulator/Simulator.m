classdef Simulator < handle
    properties
        sample_rate;
        samples_avaliable;
        isrunning;
        nmeas;
        data;
        timer;
        
    end
    
    
    methods
        function obj=Simulator
            obj.isrunning=false;
            obj.samples_avaliable=0;
            obj.sample_rate=10;
            obj.nmeas=0;
            obj.timer=timer;
            set(obj.timer,'ExecutionMode','fixedRate');
            set(obj.timer,'Period',1/obj.sample_rate);
            set(obj.timer,'TimerFcn',@updatedata);
            set(obj.timer,'Userdata',obj);
            
        end
                   
       function obj=setLaserState(obj,lIdx,state)
            % do nothing
       end
   
       function obj=setDetectorGain(obj,dIdx,gain)
           % do nothing
       end
       
       function obj = sendMLinfo(object,probe)
           obj.nmeas=height(probe.link);
           obj.data = nirs.testing.simARNoise( probe, [0:30000]/obj.sample_rate);
       end
       
       function obj = Start(obj)
           start(obj.timer);
       end
       
       
       function obj= Stop(obj);
           stop(obj.timer);
       end
       
       function [d,t]=get_samples(obj,nsamples)
           if(nargin==1)
               nsamples=1;
           end
           obj.samples_avaliable=min(obj.samples_avaliable,length(obj.data.time));
           nsamples=min(nsamples,obj.samples_avaliable);
           if(nsamples==0)
               t=[];
               d=zeros(0,obj.nmeas);
               return
           end
           t=obj.data.time(1:nsamples);
           d=obj.data.data(1:nsamples,:); 
           obj.data.time(1:nsamples)=[];
           obj.data.data(1:nsamples,:)=[];
           
       end
       
     
end
       
end

function updatedata(varargin)
% Note- handles objects are passed by reference so this will change the
% main object
    obj=get(varargin{1},'Userdata');
    obj.samples_avaliable=1;
end


