function SetUseTDML(obj,useTDML)
%This is the parent function for starting a TechEn device

try
    SetUseTDML(obj.system,useTDML);   
catch
    warning('SetUseTDML failed');
end

