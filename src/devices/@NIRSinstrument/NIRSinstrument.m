classdef NIRSinstrument
  
   
   properties(Hidden = true)
        device;
        type;
        
   end
   properties( Dependent = true )
       samples_avaliable;
       isrunning;
       sample_rate;
   end
   
   
   methods
       function obj=NIRSinstrument(type)
           obj.type=type;
       end
       
       function n = get.isrunning(obj)
           n=obj.device.isrunning;
       end
       
       function n=get.sample_rate(obj)
           n=obj.device.sample_rate;
       end
       function n = get.samples_avaliable(obj)
           n=obj.device.samples_avaliable;
       end
       
       function obj=set.type(obj,type)
           if(strcmp(type,'Simulator'))
               obj.device=Simulator;
           elseif(strcmp(type,'BTNIRS'))
               obj.device=BTNIRS;
           else
               error('unknown type');
           end
            
       end
       function obj=setLaserState(obj,lIdx,state)
          obj.device=obj.device.setLaserState(lIdx,state);
       end
   
       function obj=setDetectorGain(obj,dIdx,gain)
           obj.device=obj.device.setDetectorGain(dIdx,gain);
       end
       
       function obj = sendMLinfo(obj,probe)
           obj.device=obj.device.sendMLinfo(probe);
       end
       
       function obj = Start(obj)
           obj.device=obj.device.Start();
       end
       
       
       function obj= Stop(obj)
           obj.device=obj.device.Stop();
       end
       
       function [d,t]=get_samples(obj,nsamples)
            [d,t]=obj.device.get_samples(nsamples);
           
           
       end
       
   end
    
    
end