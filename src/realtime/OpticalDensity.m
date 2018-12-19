classdef OpticalDensity < handle
  
    properties(Hidden = true)
       runningMean; 
       cnt=0;
    end
    
    methods
        function obj = OpticalDensity
           obj.runningMean=[];
           obj.cnt=0;
           
        end
        
        
        function data = update(obj,data)
            
            if(isempty(obj.runningMean))
                obj.runningMean=mean(data,2);
                obj.cnt=size(data,2);
            end
            obj.runningMean=(obj.runningMean*obj.cnt+mean(data,2)*size(data,2))/(obj.cnt+size(data,2));
            obj.cnt=obj.cnt+size(data,2);
            data = -log(data)+log(obj.runningMean)*ones(1,size(data,2));
            
        end
    end
    
end
