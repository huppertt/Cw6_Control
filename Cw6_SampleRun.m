%Sample script to run my Cw6 controller

cw=actxcontrol('CW6CONTROLACTIVEX.Cw6ControlactivexCtrl.1');

%These are the methods for this controller
disp(methods(cw));

%Example 1: Normal run
cw.SetUseTDML(0);  %Run in normal mode (Default);
for idx=0:15
    %All on;
    cw.SetLaserState(idx,1);  
end

cw.StartDAQ();  %Start collection
pause(10);
cw.StopDAQ();  %Stop collection
cw.AllOff();   %All lasers off
data=[];
maxd=32^2+8+2;
for idx2=1:floor(cw.SamplesAvaliable/maxd)*maxd; 
    data(idx2)=cw.GetData(1); 
    %The GetData function will only return a single value at a time
    %I am trying to fix this... but it is a limit of activeX contollers
end;

data=reshape(data,maxd,[]);


%Example 2: TDM

%-----------------------
cw.AllOff();   %All lasers off
for idx=1:16
    cw.SetLaserState(idx,1);  %Lasers on
end
for idx=1:16;
    cw.SetDetGains(idx-1,1);
end
cw.SetDwellTime(10);
cw.SetState(0);  %Set as state #1

%-----------------------
cw.AllOff();   %All lasers off
for idx=1:16
    cw.SetLaserState(idx-1,1);  %Lasers on
end
for idx=7:16;
    cw.SetDetGains(idx-1,100);
end
cw.SetDwellTime(10);
cw.SetState(1);  %Set as state #2

%-----------------------
cw.AllOff();   %All lasers off
for idx=1:6
    cw.SetLaserState(idx-1,0);  %Lasers on
end
for idx=1:16;
    cw.SetDetGains(idx-1,1);
end
cw.SetDwellTime(10);
cw.SetState(2);  %Set as state #3
%-----------------------

cw.SetUseTDML(1);  %Run in TDM mode;

cw.StartDAQ();  %Start collection
pause(100);
cw.StopDAQ();  %Stop collection
cw.AllOff();   %All lasers off
data=[];
maxd=32^2+8+2;
for idx2=1:floor(cw.SamplesAvaliable/maxd)*maxd; 
    data(idx2)=cw.GetData(1); 
    %The GetData function will only return a single value at a time
    %I am trying to fix this... but it is a limit of activeX contollers
end;
data=reshape(data,maxd,[]);
