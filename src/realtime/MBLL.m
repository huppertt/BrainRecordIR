classdef MBLL < handle
   properties
       PPF=.1;
       probeout;
   end
    properties(Hidden = true)
       Emtx; 
       
    end
    
    methods
        function obj = MBLL
           obj.Emtx=[];
           
        end
        
        function obj = set.PPF(obj,PPF)
            obj.PPF=PPF;
        end
        
        function obj = initialize(obj,probe)
            obj.Emtx = zeros(height(probe.link));
            usd=unique(probe.link(:,1:2));
            for i=1:height(usd)
                lst=find(probe.link.source==usd.source(i) &...
                    probe.link.detector==usd.detector(i));
                lambda = probe.link.type(lst);
                ext = nirs.media.getspectra( lambda );
                d=(probe.distances(lst).*obj.PPF)*ones(1,2);
                ext=ext(:,1:2).*d*1E-6;
                iE=inv(ext'*ext)*ext';
                obj.Emtx(lst,lst)=iE;
                
            end
            t=unique(probe.link.type);
            link=probe.link;
            link(ismember(probe.link.type,t([1 2])),:);
            link.type=repmat({'hbo','hbr'}',height(usd),1);
            obj.probeout=probe;
            obj.probeout.link=link;
        end
        
        
        
        function data = update(obj,data)
            
            if(isempty(obj.Emtx))
                obj.nmeas=size(data,1);
               
            end
            data = obj.Emtx*data;
            
        end
    end
    
end
