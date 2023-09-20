function flag=isrunning(foo)
global NIRS2device;
flag=NIRS2device.isrunning;

if(flag==1)
    flag='on';
else
    flag='off';
end

return