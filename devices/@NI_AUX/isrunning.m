function flag=isrunning(foo)
global NI_Auxdevice;
flag= NI_Auxdevice.isrunning;

if(flag==1)
    flag='on';
else
    flag='off';
end

return