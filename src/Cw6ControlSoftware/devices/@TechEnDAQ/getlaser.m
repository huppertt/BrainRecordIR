function states=getlaser(obj,laser)

if(~exist('laser'))
    laser=[];
end

    try
        states=feval(obj.Callbacks.GetLaserStates,laser);   
    catch
        states=[];
         warning('get laserfailed');
    end


return