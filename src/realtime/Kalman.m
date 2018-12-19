classdef Kalman < handle
    properties
        % Kalman parameters
        R;
        Q;
        Cp;
        X;
    end
    
    methods
        function obj = Kalman
            obj.R=1;
            obj.Q=0;
            obj.Cp=1;
            obj.X=0;
        end
        
        function xx = update(obj,data)
            
            if(size(data,2)>1)
                for i=1:size(data,2)
                    data(:,i)=obj.update(data(:,i));
                end
                return;
            end
            
            yhat = obj.X;
            obj.Cp = obj.Cp + obj.Q;
            innov = data - yhat;
            K = obj.Cp*pinv(obj.Cp+obj.R);
            obj.X = obj.X + K*innov;
            obj.Cp = (1 - K)*obj.Cp;
            
            xx=obj.X;
        end
        
    end
    
end

