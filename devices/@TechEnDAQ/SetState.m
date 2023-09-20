function SetState(obj,state,dwelltime,gains,lasers)
%This is the parent function for starting a TechEn device

try
    SetState(obj.system,state,dwelltime,gains,lasers);   
catch
    warning('SetState failed');
end

