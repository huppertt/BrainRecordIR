classdef KalmanGLM < handle
    properties
        modelorder=4;
        numparams=1;
        tune=.1;
        basis=Dictionary({'default'}, {nirs.design.basis.Canonical()});
    end
     properties( SetAccess = private )
         rGLM=KalmanARWLS.empty;
         conditions      % list of stim conditions
     end
     properties ( Dependent = true )
        Stats;  % channel stats variable
     end
     properties(Hidden = true)
         probe;
         nummeas=1;
         demographics;
         stimulus;
         Fs;
     end
     
     methods
         function initfilter(obj,probe)
             obj.nummeas=height(probe.link);
             obj.probe=probe;
             for i=1:obj.nummeas
                KF1 = RobustKalmanFilter(obj.tune^2*eye(obj.numparams+1));
                KF1.Q(end,end)=0;
                KF2 = KalmanAR(obj.modelorder);
                obj.rGLM(i)=KalmanARWLS(KF1,KF2);
             end
         end
         
         function update(obj,data,time)
             
             if(nargin<3)
                 time=data.time;
             end
             
             [X,obj.conditions] = nirs.design.createDesignMatrix(data);
             if(~isempty(X));
                 X(:,end+1)=1;
                 lst=find(ismember(data.time,time));
                 for j=1:length(lst)
                     for i=1:obj.nummeas
                         obj.rGLM(i).update(data.data(lst(j),i),X(lst(j),:));
                     end
                 end
                 obj.Fs=data.Fs;
                 obj.stimulus=data.stimulus;
                 obj.demographics=data.demographics;
             end
         end
         function Stats =get.Stats(obj)
             %% 
             Stats=nirs.core.ChannelStats;
             Stats.probe=obj.probe;
             
             if(isempty(obj.conditions))
                 return
             end
             
             beta=zeros(obj.nummeas*length(obj.conditions),1);
             covb=eye(obj.nummeas*length(obj.conditions));
             cnt=1;
             for j=1:length(obj.conditions)
                for i=1:obj.nummeas
                    beta(cnt)=obj.rGLM(i).B(j);
                    covb(cnt,cnt)=obj.rGLM(i).covB(j,j);
                    
                    cond{cnt,1}=obj.conditions{j};
                    cnt=cnt+1;
                end
             end
                 
             Stats.variables = [repmat(obj.probe.link,1,length(obj.conditions)) table(cond)];
             Stats.beta = beta;
             Stats.covb = covb;
             Stats.dfe  = obj.rGLM(1).dfe;
                
             
             stim=Dictionary;
             for j=1:obj.stimulus.count;
                 ss=obj.stimulus.values{j};
                 if(isa(ss,'nirs.design.StimulusEvents'))
                     s=nirs.design.StimulusEvents;
                     s.name=ss.name;
                     s.dur=mean(ss.dur);
                     stim(obj.stimulus.keys{j})=s;
                 end
             end
             
             Stats.basis.base=obj.basis;
             Stats.basis.Fs=obj.Fs;
             Stats.basis.stim=stim;
             %% 
             
             
         end
        
        function set.tune(obj,tune)
            obj.tune=tune;
            for i=1:obj.nummeas
                obj.rGLM(i).modelKF.Q=obj.tune^2*eye(obj.numparams+1);
                obj.rGLM(i).modelKF.Q(end,end)=0;
            end
        end
        
     end
end