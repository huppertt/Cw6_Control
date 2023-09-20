function setlaserpower(obj,power)

    try
        setlaserpower(obj.system,power);   
    catch
         warning('laser change failed');
    end


return