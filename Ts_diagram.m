function [ ] = Ts_diagram(eta_siP,eta_siT)
%Note : changer les noms des variables, peu coherent
%mettre commentaires
%Faire un beau graphe !
global state
T=0.1:0.1:373.9459;
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
% diagram T-s
plot(sl_t,T,sv_t,T)


%% feedPumpCompression plot
%CODE A VERIFIER !!!!! OK VALABLE QUE LORSQUE LE TITRE EST DEFINI CAD
%LORSQUE L ETAT 4 EST DANS LA CLOCHE --> a modifier
hold on
plot(state.s(1),state.T(1),'o')

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
plot(s_pump,T_pump)


%% steamGenerator Plot
hold on
plot(state.s(2),state.T(2),'o')

%part1
Tsat_Gen=XSteam('Tsat_p',state.p(3));
T_Gen1=state.T(2):(Tsat_Gen-state.T(2))*0.01:Tsat_Gen-0.01;
sGen1=zeros(1,length(T_Gen1));
for i=1:length(T_Gen1)
    sGen1(i)=XSteam('s_pt',state.p(3),T_Gen1(i));
end

hold on
plot(sGen1,T_Gen1)
%part2
sV_pGen=XSteam('sv_p',state.p(3));
sL_pGen=XSteam('sl_p',state.p(3));

hold on
plot([sL_pGen sV_pGen],[Tsat_Gen Tsat_Gen])
%part3
Tsur_Gen2=XSteam('T_ps',state.p(3),state.s(3));
T_Gen2=Tsat_Gen:(Tsur_Gen2-Tsat_Gen)*0.01:Tsur_Gen2;
sGen2=zeros(1,length(T_Gen2));

for i=1:length(T_Gen2)
    sGen2(i)=XSteam('s_pt',state.p(3),T_Gen2(i));
end

hold on
plot(sGen2,T_Gen2)

%% Turbine plot
hold on
plot(state.s(3),state.T(3),'o')

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
plot(s_turb,T_turb)

%% Condenser
hold on
plot(state.s(4),state.T(4),'o')

if isnan(state.x(4))
    
    %To be done
else
    plot([state.s(4),state.s(1)],[state.T(4),state.T(1)])
end

end

