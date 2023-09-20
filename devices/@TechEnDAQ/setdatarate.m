function setdatarate(obj,rate)

try
    setdatarate(obj.system,rate);
catch
    warning('set data rate failed');
end


return