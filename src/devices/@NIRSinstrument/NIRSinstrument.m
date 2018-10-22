classdef NIRSinstrument
   properties
        isrunning;
        type;
        sample_rate;
        sample_avaliable;
        laserstates;
        lasergains;
        detgains;
        maxLasers=32*4;
        device;
   end
   
   methods
       function obj=NIRSinstrument(type)
            obj.isrunning=false;
            obj.type=type;
            obj.sample_rate=10;
            obj.laserstates=false(obj.maxLasers,1);
       end
                   
       function obj=set.type(obj,type)
           if(strcmp(type,'Simulator'))
               obj.device=Simulator;
           else
            error('unknown type');
           end
            
       end
       function obj=setLaserState(obj,lIdx,state)
            obj.laserstates(lIdx)=state;
            obj.device.setLaserState(lIdx,state);
       end
   
       function obj=setDetectorGain(obj,dIdx,gain)
           obj.detgains(dIdx)=gain;
           obj.device.setDetectorGain(dIdx,gain);
       end
       
       function obj = sendMLinfo(object,probe)
           obj.device=obj.device.sendMLinfo(probe);
       end
       
       function obj = Start(obj)
           obj.device.Start();
       end
       
       
       function obj= Stop(obj)
           obj.device.Stop();
       end
       
       function [d,t]=get_samples(obj,nsamples)
            [d,t]=obj.device.get_samples(nsamples);
           
           
       end
       
   end
    
    
end