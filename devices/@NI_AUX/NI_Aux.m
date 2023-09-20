function obj = NIRS2System
%This function creates the initial
%instance of a TechEn device.  Only one
%instance may exist.  

device.name='NI Aux';
%device.instrument=actxcontrol('CW6CONTROLACTIVEX.Cw6ControlactivexCtrl.1',[0 0 .01 .01]);

if(~isa(device,'NI_Aux'))
    obj=class(device,'NI_Aux');
else
    obj=device;
end

return