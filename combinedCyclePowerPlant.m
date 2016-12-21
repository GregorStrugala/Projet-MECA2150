function [stateSteam,stateGas,mSteamLP,mSteamHP,mSteamTot,mGas,ma,mc] = combinedCyclePowerPlant(deltaT,Triver,HPsteamPressure,dTpinch,dTapproach,Ta,Tf,fuel,r,PeGT,steamDiagrams,gasDiagrams)
%close all;
%STEAMPOWERPLANT characterises a steam power plant using Rankine cycle.
%   STEAMPOWERPLANT(deltaT, Triver, Tmax, steamPressure, Pe, n) displays a table
%   with the values of the variables p, T, x, h, s at the differents states
%   of the cycle, along with the work of the cycle Wmcy.
%   deltaT is the difference of temperature between the cold source and the
%   condensation temperature of the fluid in the cycle, Triver is the
%   temperature of the cold source, Tmax is the temperature of the
%   superheated vapour before it expands, steamPressure is the pressure
%   at the same state, Pe is the electric power that the steam power plant
%   produces and n is the number of feed heating.

% ROBUSTESSE : pour la robustesse du code ce serait bien de mettre des
% conditions sur nF, ex: si feedHeat=0 et nF !=0

%% Robustness %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% switch nargin % Check for correct inputs, set efficiency to 1 if none is specified.
%     case 0
%         msgID = 'STEAMPOWERPLANT:NoState';
%         msg = 'Initial state must be specified.';
%         baseException = MException(msgID,msg);
%         throw(baseException)
%     case 1
%         msgID = 'STEAMPOWERPLANT:NodT';
%         msg = 'dT must be specified.';
%         baseException = MException(msgID,msg);
%         throw(baseException)
%     case 2
%         msgID = 'STEAMPOWERPLANT:NoTriver';
%         msg = 'Triver must be specified.';
%         baseException = MException(msgID,msg);
%         throw(baseException)
%     case 3
%         msgID = 'STEAMPOWERPLANT:NoTmax';
%         msg = 'Tmax must be specified.';
%         baseException = MException(msgID,msg);
%         throw(baseException)
%     case 4
%         msgID = 'STEAMPOWERPLANT:NoSteamPressure';
%         msg = 'steamPressure must be specified.';
%         baseException = MException(msgID,msg);
%         throw(baseException)
% end

% State calculations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Pe=225e3;
%Ta=15;
%Tf=1250;
%r=18;
etaC=0.9;
etaT=0.9;
kcc=0.95;
kmec=0.015;
%fuel='CH4';
%call to the gasTurbine function:
[stateGas,mGas,nM,gasTurbMecLoss,gasTurbCombLossEx,gasTurbCompLossEx,gasTurbLossEx,ma,mc] = gasTurbine(PeGT,Ta,Tf,r,kcc,etaC,etaT,kmec,gasDiagrams,fuel);

%efficiencies
eta_mec=0.98;
%eta_gen=0.945;
eta_siT=0.9;
eta_siP=0.85;

%temperature of condensation
Tcond=Triver+deltaT;

% STEAM STATE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stateNumberSteam = 6;
stateSteam(stateNumberSteam).p = []; %preallocation
stateSteam(stateNumberSteam).T = [];
stateSteam(stateNumberSteam).x = [];
stateSteam(stateNumberSteam).h = [];
stateSteam(stateNumberSteam).s = [];
stateSteam(stateNumberSteam).e = [];

for i=1:stateNumberSteam-1
    stateSteam(i).p = [];
    stateSteam(i).T = [];
    stateSteam(i).x = [];
    stateSteam(i).h = [];
    stateSteam(i).s = [];
    stateSteam(i).e = [];
    
end

% Given parameters :
stateSteam(1).T=Tcond;
stateSteam(1).p=XSteam('psat_T',Tcond);

stateSteam(6,1).p=HPsteamPressure;
stateSteam(6,2).p=HPsteamPressure;
stateSteam(6,2).T=XSteam('Tsat_p',HPsteamPressure);
stateSteam(6,3).p=HPsteamPressure;
stateSteam(6,3).T=XSteam('Tsat_p',HPsteamPressure);

%definition of the state(3) : complete!
ToGasTurbine=stateGas(4).T;
stateSteam(3).T=ToGasTurbine-dTapproach;
stateSteam(3).p=HPsteamPressure;
stateSteam(3).x=nan;
stateSteam(3).s = XSteam('s_pT',HPsteamPressure,stateSteam(3).T);
stateSteam(3).h = XSteam('h_pT',HPsteamPressure,stateSteam(3).T);
stateSteam(3).e = exergy(stateSteam(3));

%We begin the cycle at the state(3)
%HP part:
[stateSteam(5),WmovHP,turbineLossEnHP,turbineLossExHP] = turbine(stateSteam(3),stateSteam(1).p,eta_siT,eta_mec);

%define the LPstreamPressure: imposing the steam quality of the LP
%expansion
stateSteam(8).T=stateSteam(6,2).T;

pSup=stateSteam(3).p;
pInf=stateSteam(5).p;
r = 1;
n=1;
nmax=50;
while abs(r) > 0.01 && n<nmax
    pGuess = (pSup+pInf)/2;
    %fprintf('pGuess = %f\n',pGuess)
    r = XSteam('h_pT',pGuess,stateSteam(8).T)-(stateSteam(3).h-eta_siT*(stateSteam(3).h-XSteam('h_ps',pGuess,stateSteam(3).s)));
    if r < 0
        pSup = pGuess;
    elseif r > 0
        pInf = pGuess;
    else
        break
    end
end
LPsteamPressure=pGuess;

%TOTAL steamflow :
[stateSteam(1),Qc,condenserLossEn,condenserLossEx] = condenser(stateSteam(5));
[stateSteam(2,1),Wop,feedPumpLossEn,feedPumpLossEx] = feedPump(stateSteam(1),LPsteamPressure,eta_siP,eta_mec);
[stateSteam(2,2),QecoLP,dExEcoLP] = economizer(stateSteam(2,1));

%HP steamflow :
[stateSteam(6,1),WopHP,pumpLossEnHP,pumpLossExHP] = feedPump(stateSteam(2,2),HPsteamPressure,eta_siP,eta_mec);
[stateSteam(6,2),QecoHP,dExEcoHP] = economizer(stateSteam(6,1));
[stateSteam(6,3),QevapHP,dExEvapHP] = evaporator(stateSteam(6,2));
QsupHP=stateSteam(3).h-stateSteam(6,3).h;
%no superheater function because state(3) is already define !

%LP steamflow :
[stateSteam(2,3),QevapLP,dExEvapLP] = evaporator(stateSteam(2,2));
TmaxLP=stateSteam(6,2).T+dTpinch;
[stateSteam(4),QsupLP,dExSuperLP] = superheater(stateSteam(2,3),TmaxLP,dTpinch);
[~,WmovLP,turbineLossEnLP,turbineLossExLP] = turbine(stateSteam(4),stateSteam(1).p,eta_siT,eta_mec);
steamWmov=[WmovLP,WmovHP];
steamTurbineLossEn=[turbineLossEnLP,turbineLossEnHP];
steamTurbineLossEx=[turbineLossExLP,turbineLossExHP];

% GAS STATE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

TgEcoLP=stateSteam(2,2).T+dTpinch;
hGecoLP = fgProp('h',TgEcoLP+273.17,nM);

TgEcoHP=stateSteam(6,2).T+dTpinch;
hGecoHP = fgProp('h',TgEcoHP+273.15,nM);


%% FLOW RATE CALCULATION

    function F = flowRate(x)
        h2prime2=stateSteam(2,3).h;
        h2prime=stateSteam(2,2).h;
        h3=stateSteam(3).h;
        h4=stateSteam(4).h;
        h6=stateSteam(6,1).h;
        h6prime=stateSteam(6,2).h;
        %h6prime2=stateSteam(6,3).h;
        F=[mGas*(hGecoHP-hGecoLP)-(x(1)*(h2prime2-h2prime)+x(1)*(h4-h2prime2)+x(2)*(h6prime-h6));
            mGas*(stateGas(4).h-hGecoHP)-(x(2)*(h3-h6prime));];
    end
x0 = [10,30];  % Make a starting guess at the solution
%options = optimoptions('fsolve','Display','iter'); % Option to display output
[x,~] = fsolve(@flowRate,x0); % Call solver
%[x,~] = fsolve(@(x) flowRate(x,state), x0);
mSteamLP=x(1);
fprintf('mSteamLP = %f\n',x(1))
mSteamHP=x(2);
fprintf('mSteamHP = %f\n',x(2))
mSteamTot=mSteamLP+mSteamHP;
fprintf('mSteamTot = %f\n',x(1)+x(2))

%% EXHAUST TEMPERATURE CALCULATION
hGexhaust=mSteamTot*(stateSteam(2,1).h-stateSteam(2,2).h)/mGas+hGecoLP;

Tsup=TgEcoLP;
Tinf=Ta;
r = 1;
n=1;
nmax=50;
while abs(r) > 0.01 && n<nmax
    Tguess = (Tsup+Tinf)/2;
    %fprintf('Tguess = %f\n',Tguess)
    hGuess = fgProp('h',Tguess+273.15,nM);
    r = hGexhaust-(hGuess);
    if r < 0
        Tsup = Tguess;
    elseif r > 0
        Tinf = Tguess;
    else
        break
    end
    n=n+1;
end
TgExhaust=Tguess;
%sGexhaust = fgProp('s',TgExhaust+273.15,nM);
eGexhaust=fgProp('e',TgExhaust+273.15,nM);

%% Table & Diagrams %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(steamDiagrams,'all')
    all = 1;
else
    all = 0;
end

% State table
if any(ismember('StateTable',steamDiagrams))||all
    M = (reshape(struct2array(stateSteam),6,10))';
    T = array2table(M,'VariableNames',{'p','T','x','h','s','e'});
    length(struct2array(stateSteam))
    disp(T)
    fprintf('\n')
end

% T-Q diagram

%HRSG_q=[stateSteam(3).h, stateSteam(6,3).h, stateSteam(6,2).h, stateSteam(4).h,stateSteam(2,3).h, stateSteam(2,2).h,stateSteam(2,1).h]
Qsteam=[0,mSteamHP*QsupHP,mSteamHP*QevapHP,mSteamHP*QecoHP+mSteamLP*QsupLP,mSteamLP*QevapLP,(mSteamTot)*QecoLP];
QsteamTot=sum(Qsteam);
%QsteamTot2=mSteamHP*(stateSteam(3).h-stateSteam(2,1).h)+mSteamLP*(stateSteam(4).h-stateSteam(2,1).h)

QsteamTransfer=zeros(1,length(Qsteam));
for i=1:length(Qsteam)
    QsteamTransfer(i)=sum(Qsteam(1:i));
end

Tgas=[stateGas(4).T,TgEcoHP,TgEcoLP,TgExhaust];
HRSGt=[stateSteam(3).T, stateSteam(6,3).T, stateSteam(6,2).T,stateSteam(2,3).T, stateSteam(2,2).T,stateSteam(2,1).T];
if any(ismember('tq',steamDiagrams))||all
    figure
    plot(QsteamTransfer/QsteamTot, HRSGt,'Color','b');
    hold on
    plot([0,QsteamTransfer(3)/QsteamTot, QsteamTransfer(5)/QsteamTot,1],Tgas,'Color', 'r');
    hold on
    plot(QsteamTransfer(1)/QsteamTot,HRSGt(1),'o')
    text(QsteamTransfer(1)/QsteamTot,HRSGt(1),'3')
    hold on
    plot(QsteamTransfer(2)/QsteamTot,HRSGt(2),'o')
    text(QsteamTransfer(2)/QsteamTot,HRSGt(2),'6''''')
    hold on
    plot(QsteamTransfer(3)/QsteamTot,HRSGt(3),'o')
    text(QsteamTransfer(3)/QsteamTot,HRSGt(3),'6''')
    hold on
    plot(QsteamTransfer(4)/QsteamTot,HRSGt(4),'o')
    text(QsteamTransfer(4)/QsteamTot,HRSGt(4),'2''''')
    hold on
    plot(QsteamTransfer(5)/QsteamTot,HRSGt(5),'o')
    text(QsteamTransfer(5)/QsteamTot,HRSGt(5),'2''')
    hold on
    plot(QsteamTransfer(5)/QsteamTot,HRSGt(5),'o')
    text(QsteamTransfer(5)/QsteamTot,HRSGt(5),'6','Position',[QsteamTransfer(5)/QsteamTot,HRSGt(5)-40])
    hold on
    plot(QsteamTransfer(6)/QsteamTot,HRSGt(6),'o')
    text(QsteamTransfer(6)/QsteamTot,HRSGt(6),'2')
    hold on
    plot(QsteamTransfer(1)/QsteamTot,stateGas(4).T,'o')
    text(QsteamTransfer(1)/QsteamTot,stateGas(4).T,'4_g')
    hold on
    plot(QsteamTransfer(3)/QsteamTot,TgEcoHP,'o')
    text(QsteamTransfer(3)/QsteamTot,TgEcoHP,'5_{HP}')
    hold on
    plot(QsteamTransfer(5)/QsteamTot,TgEcoLP,'o')
    text(QsteamTransfer(5)/QsteamTot,TgEcoLP,'5_{BP}')
    hold on
    plot(QsteamTransfer(6)/QsteamTot,TgExhaust,'o')
    text(QsteamTransfer(6)/QsteamTot,TgExhaust,'5_{g}')
    %hold on
    %plot(QsteamTransfer(end-1:end)/QsteamTot, HRSGt(end-1:end),'Color','m');
    %hold on 
    %plot(QsteamTransfer(end-2:end-1)/QsteamTot, HRSGt(end-2:end-1),'Color','r');
    hold off
end

% T-S Diagram
if any(ismember('ts',steamDiagrams))||all
    figure
    Ts_diagramCombined(stateSteam,eta_siP,eta_siT,'2P');
end

% H-S Diagram
if any(ismember('hs',steamDiagrams))||all
    figure
     hs_diagramCombined(stateSteam,eta_siP,eta_siT,'2P');
end

%% Energetic Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


mecLoss=gasTurbMecLoss+steamTurbineLossEn*x'+mSteamTot*feedPumpLossEn+mSteamHP*pumpLossEnHP;
condenserLossEn=mSteamTot*condenserLossEn;
chimneyLoss=mGas*abs(stateGas(1).h-hGexhaust);
lossEn=[mecLoss,condenserLossEn,chimneyLoss];
PeST=(abs(steamWmov*x')-(mSteamTot*Wop+mSteamHP*WopHP))*eta_mec;
if any(ismember('EnPie',steamDiagrams))||all
    %Energy pie chart
    %pie
    figure
    h = pie([PeGT,PeST,lossEn]);
    hText = findobj(h,'Type','text'); % text object handles
    percentValues = get(hText,'String'); % percent values
    txt = {'GT effective power ';'ST effective power';'Mechanical losses ';'Condenser loss ';'Chimney loss '};
    combinedtxt = strcat(txt,percentValues);
    set(hText,{'String'},combinedtxt);
    legend(txt);
end
%% Exergetic Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


rotorIrr=gasTurbCompLossEx+gasTurbLossEx+steamTurbineLossEx*x'+mSteamTot*feedPumpLossEx+mSteamHP*pumpLossExHP;
condenserLossEx=mSteamTot*condenserLossEx;
chimneyLossEx=mGas*eGexhaust;
dExSuperHP=abs(stateSteam(3).e-stateSteam(6,3).e);
heatedFluidExergy=mSteamTot*(dExEcoLP)+mSteamLP*(dExEvapLP+dExSuperLP)+mSteamHP*(dExEcoHP+dExEvapHP+dExSuperHP);
transLossEx=mGas*(stateGas(4).e-eGexhaust)-(heatedFluidExergy);
lossEx=[mecLoss,condenserLossEx,rotorIrr,chimneyLossEx,transLossEx,gasTurbCombLossEx];
if any(ismember('ExPie',steamDiagrams))||all
    %Exergy pie chart
    % pie
    figure
    h = pie([PeGT,PeST,lossEx]);
    hText = findobj(h,'Type','text'); % text object handles
    percentValues = get(hText,'String'); % percent values
    txt = {'GT effective power ';'ST effective power';'Mechanical losses ';'Condenser loss ';'Rotor unit irreversibilities ';'Chimney loss ';'Heat transfer irreversibilities ';'Combustion irreversibilities '};
    combinedtxt = strcat(txt,percentValues);
    set(hText,{'String'},combinedtxt);
    legend(txt);
end
%% Efficiencies

% Steam part
eta_toten=PeST/(mGas*(stateGas(4).h-hGexhaust));
eta_cyclen=PeST/(eta_mec*(QsteamTot));
eta_cyclen2=(QsteamTot-abs(Qc)*mSteamTot)/QsteamTot;

eta_cyclex=PeST/(eta_mec*heatedFluidExergy);
eta_cyclex2=PeST/(eta_mec*(mSteamLP*(stateSteam(4).e-stateSteam(2,1).e)+mSteamHP*(stateSteam(3).e-stateSteam(2,1).e)));
eta_totex=PeST/(mGas*(stateGas(4).e-eGexhaust));
eta_chimnex=(stateGas(4).e-eGexhaust)/stateGas(4).e;
eta_transex=heatedFluidExergy/(mGas*(stateGas(4).e-eGexhaust));
%% FGPROP FUNCTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function that calculates the enthalpy of gas for a given temperature
    function x = fgProp(prop,T,nM)
        T0 = 273.15;
        switch prop
            case 'h'
                base = [enthalpy('CO2',T) enthalpy('H2O',T) enthalpy('O2',T) enthalpy('N2',T)];
                base0 = [enthalpy('CO2',T0) enthalpy('H2O',T0) enthalpy('O2',T0) enthalpy('N2',T0)];
                x = (base - base0)*nM';
            case 's'
                base = [entropy('CO2',T) entropy('H2O',T) entropy('O2',T) entropy('N2',T)];
                base0 = [entropy('CO2',T0) entropy('H2O',T0) entropy('O2',T0) entropy('N2',T0)];
                x = (base - base0)*nM';
            case 'e'
                T0 = 273.15 + 15;
                deltaH = fgProp('h',T,nM) - fgProp('h',T0,nM);
                deltaS = fgProp('s',T,nM) - fgProp('s',T0,nM);
                x = deltaH - T0*deltaS;
        end
    end
end