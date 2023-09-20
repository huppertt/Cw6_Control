function SetUseTDML(foo,useTDM);
global simulatordevice;

if(useTDM)
    warning('Simulator does not support Time-multiplexing');
end

return