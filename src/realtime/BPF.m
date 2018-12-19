classdef BPF < handle
   
    properties(Hidden = true)
        fa;
        fb;
        filterkernelB;
        filterkernelA;
        filterOrder=5;
        nmeas;
        x;
        y;
    end
    
    methods
        function obj = BPF
            obj.x=[];
            obj.y=[];
        end
        
        function initfilter(obj,fb,fa)
            obj.fa=fa;
            obj.fb=fb;
            obj.filterOrder=length(fa);
        end
        
        function data = update(obj,data)
            
            if(size(data,2)>1)
                for i=1:size(data,2)
                    data(:,i)=obj.update(data(:,i));
                end
                return;
            end
                    
            
            if(isempty(obj.y))
                obj.nmeas=size(data,1);
               
                obj.filterkernelB=repmat(obj.fb(end:-1:1)/obj.fa(1),obj.nmeas,1);
                obj.filterkernelA=repmat(obj.fa(end:-1:2)/obj.fa(1),obj.nmeas,1);
                
                obj.x=zeros(obj.nmeas,obj.filterOrder);
                obj.x(:,1:obj.filterOrder)=repmat(data,1,obj.filterOrder);
                
                obj.y=zeros(obj.nmeas,obj.filterOrder-1);
                obj.y(:,1:obj.filterOrder-1)=repmat(data,1,obj.filterOrder-1);
            end
            
            
            obj.x(:,[1:obj.filterOrder-1])=obj.x(:,[2:obj.filterOrder]);
            obj.x(:,obj.filterOrder)=data;
            
            data=sum(obj.filterkernelB.*obj.x,2)-sum(obj.filterkernelA.*obj.y,2);
            
            obj.y(:,[1:obj.filterOrder-2])=obj.y(:,[2:obj.filterOrder-1]);
            obj.y(:,obj.filterOrder-1)=data;
        end
    end
    
end

