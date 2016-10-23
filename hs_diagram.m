function [ ] = hs_diagram(eta_siP, eta_siT)
%function
global state
T=0.01:0.1:373.945;
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

figure;
% diagram h-s
plot(sl_t,h_psl,sv_t,h_psv)

%% feedPumpCompression plot
%CODE A VERIFIER !!!!! OK VALABLE QUE LORSQUE LE TITRE EST DEFINI CAD
%LORSQUE L ETAT 4 EST DANS LA CLOCHE --> a modifier
hold on
plot(state.s(1),state.h(1),'o')


%eta_siP=0.8;
p_pump=state.p(1):abs((state.p(2)-state.p(1)))*0.1:state.p(2);
hs_pump=zeros(1,length(p_pump));
h_pump=zeros(1,length(p_pump));
s_pump=zeros(1,length(p_pump));
T_pump=zeros(1,length(p_pump));
for i=1:length(p_pump)
    if i == 1
        hs_pump(i)=state.h(1);%XSteam('h_ps',p_pump(i),state.s(1));
        h_pump(i)=state.h(1);
        s_pump(i)=state.s(1);
        T_pump(i)=state.T(1);
        
    elseif i==length(p_pump)
        h_pump(i)=state.h(2);
        s_pump(i)=state.s(2);
        T_pump(i)=state.T(2);
    else
        hs_pump(i)=XSteam('h_ps',p_pump(i),state.s(1));
        h_pump(i)=((hs_pump(i)-state.h(1)))/eta_siP+state.h(1);
        s_pump(i)=XSteam('s_ph',p_pump(i),h_pump(i));
        T_pump(i)=XSteam('T_ps',p_pump(i),s_pump(i));
    end
end
hold on
plot(s_pump,h_pump)


%% steamGenerator Plot
hold on
plot(state.s(2),state.h(2),'o')

%part1
%Tsat_Gen=XSteam('Tsat_p',state.p(3));
sl_p=XSteam('sl_p',state.p(2));
s_Gen1=state.s(2):(sl_p-state.s(2))*0.01:sl_p-0.01;
h_Gen1=zeros(1,length(s_Gen1));
for i=1:length(s_Gen1)
    h_Gen1(i)=XSteam('h_ps',state.p(3),s_Gen1(i));
end

hold on
plot(s_Gen1,h_Gen1)

%part2
sv_pGen=XSteam('sv_p',state.p(3));
sl_pGen=XSteam('sl_p',state.p(3));
sGen2=sl_pGen:abs(sv_pGen-sl_pGen)*0.01:sv_pGen;
hGen2=zeros(1,length(sGen2));
for i=1:length(sGen2)
    hGen2(i)=XSteam('h_ps',state.p(2),sGen2(i));
end
hold on
plot(sGen2,hGen2)

%part3
%s_sur_Gen2=XSteam('T_ps',state.p(3),state.s(3));
sGen3=sv_pGen:(state.s(3)-sv_pGen)*0.01:state.s(3);
hGen3=zeros(1,length(sGen3));

for i=1:length(sGen3)
    hGen3(i)=XSteam('h_ps',state.p(3),sGen3(i));
end

hold on
plot(sGen3,hGen3)

%% Turbine plot
hold on
plot(state.s(3),state.h(3),'o')

%eta_siT=0.6;
p_turb=state.p(4):abs((state.p(3)-state.p(4)))*0.0001:state.p(3);
p_turb = fliplr(p_turb);
hs_turb=zeros(1,length(p_turb));
h_turb=zeros(1,length(p_turb));
s_turb=zeros(1,length(p_turb));
T_turb=zeros(1,length(p_turb));
for i=1:length(p_turb)
    if i == 1
        hs_turb(i)=state.h(4);%XSteam('h_ps',p_pump(i),state.s(1));
        h_turb(i)=state.h(3);
        s_turb(i)=state.s(3);
        T_turb(i)=state.T(3);
        
    elseif i==length(p_turb)
        h_turb(i)=state.h(4);
        s_turb(i)=state.s(4);
        T_turb(i)=state.T(4);
    else
        hs_turb(i)=XSteam('h_ps',p_turb(i),state.s(3));
        h_turb(i)=-((state.h(3))-hs_turb(i))*eta_siT+state.h(3);
        s_turb(i)=XSteam('s_ph',p_turb(i),h_turb(i));
        T_turb(i)=XSteam('T_ps',p_turb(i),s_turb(i));
    end
end
hold on
plot(s_turb,h_turb)

%% Condenser
hold on
plot(state.s(4),state.h(4),'o')
if isnan(state.x(4))
    
    %To be done
else
    s_cond=state.s(1):abs((state.s(4)-state.s(1)))*0.01:state.s(4);
    s_cond = fliplr(s_cond);
    p_cond=state.p(4);
    h_cond=zeros(1,length(s_cond));
    for i=1:length(s_cond)
        h_cond(i)=XSteam('h_ps',p_cond,s_cond(i));
    end
    plot(s_cond,h_cond)
end

end

