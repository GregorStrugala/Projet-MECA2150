function [ ] = diagrams()
%function 

T=0.1:0.01:373.945;
%Preallocation
sv_t=zeros(1,length(T));
sl_t=zeros(1,length(T));
psat=zeros(1,length(T));
h_psl=zeros(1,length(T));
h_psv=zeros(1,length(T));

for index=1:length(T)
    sv_t(index)=XSteam('sv_t',T(index));
    sl_t(index)=XSteam('sl_t',T(index));
    psat(index)=XSteam('psat_t',T(index));
    h_psl(index)=XSteam('h_ps',psat(index),sl_t(index));
    h_psv(index)=XSteam('h_ps',psat(index),sv_t(index));
end

% diagram T-s
plot(sl_t,T,sv_t,T)
figure(2);

% diagram h-s
plot(sl_t,h_psl,sv_t,h_psv)

end

