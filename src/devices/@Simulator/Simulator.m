classdef Simulator < handle
    properties
        sample_rate;
        isrunning;
    end
    properties( Dependent = true )
        samples_avaliable;
        isconnected;
        info;
    end
    
    
    properties(Hidden = true)
       data;
       nmeas;
       cnt;
       timer;
       probe;
    end
    methods
        function obj=Simulator
            obj.isrunning=false;
            obj.sample_rate=4;
            obj.nmeas=0;
            obj.timer=timer;
            obj.cnt=0;
            set(obj.timer,'ExecutionMode','fixedRate');
            set(obj.timer,'Period',1/obj.sample_rate);
            set(obj.timer,'TimerFcn',@timerfcn);
             
        end
        
         function n= get.info(obj)
            n='Connected: Data Simulator';
        end
        
         function n= get.isconnected(obj)
            n=true;
        end
                   
        function n = get.samples_avaliable(obj)
            n=min(get(obj.timer,'TasksExecuted')-obj.cnt,length(obj.data.time));
        end
       function obj=setLaserState(obj,lIdx,state)
            % do nothing
       end
   
       function obj=setDetectorGain(obj,dIdx,gain)
           % do nothing
       end
       function obj = setSrcPower(obj,sIdx,val)
           % do nothing
       end
       
       function obj = sendMLinfo(obj,probe)
           obj.nmeas=height(probe.link);
           obj.probe=probe;
       end
       
       function obj = Start(obj)
           obj.cnt=0;
           obj.isrunning=true;
           obj.data = nirs.testing.simARNoise( obj.probe, [0:30000]/obj.sample_rate);
           j=nirs.modules.Resample;
           j.Fs=obj.sample_rate;
           obj.data=j.run(obj.data);
           obj.timer=timer;
           obj.cnt=0;
           set(obj.timer,'ExecutionMode','fixedRate');
           set(obj.timer,'Period',1/obj.sample_rate);
           set(obj.timer,'TimerFcn',@timerfcn);
           
           start(obj.timer);
       end
       
       
       function obj= Stop(obj);
           obj.isrunning=false;
           stop(obj.timer);
       end
       
       function [d,t]=get_samples(obj,nsamples)
           if(nargin==1)
               nsamples=1;
           end
           nsamples=min(nsamples,obj.samples_avaliable);
           obj.cnt=obj.cnt+nsamples;
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

function timerfcn(varargin)

end

