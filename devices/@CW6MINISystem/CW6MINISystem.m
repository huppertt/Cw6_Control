function obj = CW6MINISystem
%This function creates the initial
%instance of a TechEn device.  Only one
%instance may exist.  

device.name='Cw6mini';
%device.instrument=actxcontrol('CW6CONTROLACTIVEX.Cw6ControlactivexCtrl.1',[0 0 .01 .01]);

if(~isa(device,'CW6MINISystem'))
    obj=class(device,'CW6MINISystem');
else
    obj=device;
end

return