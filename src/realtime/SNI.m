classdef SNI < handle
   % This function computes the structured noise index (e.g.
   % signal-to-noise estimate) in real-time
    
    properties
       windowlength=60;
       method='SNR';
    end
    properties(Hidden = true)
        previousdata;
        fa1;
        fa2;
        fb1;
        fb2;
    end
    
    methods
        function obj = SNI
            obj.previousdata=[];
        end
        
        
        
        function sni = update(obj,data)
            
            if(size(data,2)>1)
                for i=1:size(data,2)
                    data(:,i)=obj.update(data(:,i));
                end
                return;
            end
                    
            
            if(isempty(obj.previousdata))
                obj.previousdata=data(:,1)*ones(1,obj.windowlength)+randn(size(data,1),obj.windowlength);
                [obj.fa1,obj.fb1]=butter(4,[.1 .25]);
                    [obj.fa2,obj.fb2]=butter(4,.25,'high');
            end
            
            obj.previousdata(:,1:end-1)=obj.previousdata(:,2:end);
            obj.previousdata(:,end)=data;
            
            switch(obj.method)
                case('SNR')
                    sni=mean(obj.previousdata,2)./std(obj.previousdata,[],2);
                case('fSNR');
                    y1=filter(obj.fa1,obj.fb1,obj.previousdata')';
                    y2=filter(obj.fa2,obj.fb2,obj.previousdata')';
                    sni=mad(y1')./mad(y2');
                    
                    
                    
                    
                case('SNI')
                    Pmax=5;
                    for i=1:size(obj.previousdata,1)
                        y=obj.previousdata(i,:)';
                        n = length(y);
                        Xf = nirs.math.lagmatrix( y, 1:Pmax);
                        Xb = nirs.math.lagmatrix(flipud( y), 1:Pmax);
                        
                        X = [ones(2*n,1) [Xf; Xb]];
                        inn=[y; flipud(y)]-X*inv(X'*X)*X'*[y; flipud(y)];
                        sni(i,1)=mad(y,1)/mad(inn(1:n),1);
                        
                    end
            end
            
            
        end
    end
    
end

