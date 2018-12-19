classdef CalcSO2 < handle
   
    properties(Hidden = true)
        RegionList;
        Kfilters;
    end
    
    methods
        function obj = CalcSO2
            obj.RegionList={};
            obj.Kfilters={};
        end
        
        function initfilter(obj,probe,ROI)
            if(~iscell(ROI)); ROI={ROI}; end;
            
            for i=1:length(ROI)
                
                [C,R]=nirs.util.ROIhelper(probe,ROI{i});
                c = zeros(height(probe.link),2);
                for ii=1:2
                    c(R{ii},ii) = C{ii};
                    c(:,ii)=c(:,ii)/sum(c(:,ii));
                    
                end
                obj.RegionList{i}=c;
                obj.Kfilters{i}=Kalman;
                obj.Kfilters{i}.X=.70;
                obj.Kfilters{i}.Q=.1;
                obj.Kfilters{i}.R=10;
            end
        end
        
        function x = update(obj,data)
            
            
            if(size(data,2)>1)
                x=zeros(length(obj.RegionList),size(data,2));
                for i=1:size(data,2)
                    x(:,i)=obj.update(data(:,i));
                end
                return;
            end
            
            for i=1:length(obj.RegionList) 
                hbo = obj.RegionList{i}(:,1)'*data;
                hbr = obj.RegionList{i}(:,2)'*data;
                x(i) = (.7*50+hbo)/(50+hbo+hbr);
                x(i) = obj.Kfilters{i}.update(x(i));
            end
            x=max(min(x,1),0);
          
        end
    end
    
end

