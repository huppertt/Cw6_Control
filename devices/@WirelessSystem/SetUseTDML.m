function SetUseTDML(foo,useTDM);
global NIRS2device;

if(useTDM)
    warning('NIRS 2 does not support Time-multiplexing');
end

return