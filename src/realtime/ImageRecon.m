classdef ImageRecon < handle
   properties
       mesh
   end
    properties(Hidden = true)
       iL;
       probe;
    end
    
    methods
        function obj = ImageRecon
            obj.iL=[];
        end
        
        function initfilter(obj,probe)
            
            mesh=probe.getmesh;
            mesh=mesh(end);
            obj.mesh=mesh;
            fwdMdl=nirs.forward.ApproxSlab;
            fwdMdl.probe=probe;
            fwdMdl.mesh=mesh;
            fwdMdl.prop=nirs.media.tissues.brain(808);
            L=fwdMdl.jacobian('spectral');
            obj.iL=pinv([L.hbo L.hbr]);
            
        end
        
        function data = update(obj,data)
            data=obj.iL*data;
           
        end
    end
    
end

