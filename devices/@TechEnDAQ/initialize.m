function initialize(obj)
%This is the parent function for starting a TechEn device

if(isempty(obj.system))
    return
end

try
    initialize(obj.system);   
catch
    error('initialize failed');
end