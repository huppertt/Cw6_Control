function states=getlaser(obj,laser)

if(~exist('laser'))
    laser=[];
end

    try
       states=getlaser(obj.system,laser); 
    catch
        states=[];
         warning('get laserfailed');
    end


return