function obj = NIRS2System
%This function creates the initial
%instance of a TechEn device.  Only one
%instance may exist.  

device.name='NIRS2';
%device.instrument=actxcontrol('CW6CONTROLACTIVEX.Cw6ControlactivexCtrl.1',[0 0 .01 .01]);

if(~isa(device,'NIRS2System'))
    obj=class(device,'NIRS2System');
else
    obj=device;
end

return