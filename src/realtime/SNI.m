classdef SNI < handle
   % This function computes the structured noise index (e.g.
   % signal-to-noise estimate) in real-time
    
    properties(Hidden = true)
         KfilterSignal;
         KfilterNoise;
    end
    
    methods
        function obj = SNI
           obj.KfilterSignal={};
           obj.KfilterNoise={};
        end
        
          function initfilter(obj)
                obj.KfilterSignal=Kalman;
                obj.KfilterSignal.X=0;
                obj.KfilterSignal.Q=.1;
                obj.KfilterSignal.R=10;
                
                obj.KfilterNoise=Kalman;
                obj.KfilterNoise.X=0;
                obj.KfilterNoise.Q=.1;
                obj.KfilterNoise.R=10;
          end
        
          
          
        function x = update(obj,data)
            
            if(length(data)>1)
                for i=1:length(data)
                    x=obj.update(data(i));
                end
                return;
            end
            
            signal = obj.KfilterSignal.update(data);
            noise =  obj.KfilterNoise.update((data-signal).^2);
            x = signal./sqrt(noise);
            
        end
    end
    
end

