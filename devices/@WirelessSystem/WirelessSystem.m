function obj = WirelessSystem
%This function creates the initial
%instance of a TechEn device.  Only one
%instance may exist.  

device.name='Wireless';
%device.instrument=actxcontrol('CW6CONTROLACTIVEX.Cw6ControlactivexCtrl.1',[0 0 .01 .01]);

if(~isa(device,'WirelessSystem'))
    obj=class(device,'WirelessSystem');
else
    obj=device;
end

return