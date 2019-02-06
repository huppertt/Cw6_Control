function T=calcTk(stim,k,AddReg)

T= 1; %sum((k-stim).^2.*exp(-(k-stim).^2/12))/4.4115;

if(T<1E-5)
    T=0;
end

T=[T AddReg];

% if(k-stim(end)<10)
%     T=1;
% else
%     T=0;
% end


return