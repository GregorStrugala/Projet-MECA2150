function [] = combinedCyclePowerPlant(deltaT,Triver,HPsteamPressure,dTpinch,dTapproach,PeGT)
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
Pe=230e3;
Ta=15+273;
Tf=1400+273;
r=18;
etaC=0.9;
etaT=0.9;
kcc=0.95;
kmec=0.015;
fuel='CH4';
%call to the gasTurbine function:
[stateGas,mGas,nM,MecLoss,CombLoss,CompLoss,TurbLoss] = gasTurbine(Pe,Ta,Tf,r,kcc,etaC,etaT,kmec,'[]',fuel);
stateGas(4).h
%efficiencies
eta_mec=0.98;
eta_gen=0.945;
eta_siT=0.89;
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
ToGasTurbine=stateGas(4).T-273.15
stateSteam(3).T=ToGasTurbine-dTapproach;
stateSteam(3).p=HPsteamPressure;
stateSteam(3).x=nan;
stateSteam(3).s = XSteam('s_pT',HPsteamPressure,stateSteam(3).T);
stateSteam(3).h = XSteam('h_pT',HPsteamPressure,stateSteam(3).T);
stateSteam(3).e = exergy(stateSteam(3));

%We begin the cycle at the state(3)
%HP part:
[stateSteam(5),Wmov,turbineLossEn,turbineLossEx] = turbine(stateSteam(3),stateSteam(1).p,eta_siT,eta_mec);

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
[stateSteam(2,1),Wop,pumpLossEn,pumpLossEx] = feedPump(stateSteam(1,1),LPsteamPressure,eta_siP,eta_mec);
[stateSteam(2,2),QecoLP] = economizer(stateSteam(2,1));

%HP steamflow :
[stateSteam(6,1),Wop,pumpLossEn,pumpLossEx] = feedPump(stateSteam(2,2),HPsteamPressure,eta_siP,eta_mec);
[stateSteam(6,2),QecoHP] = economizer(stateSteam(6,1));
[stateSteam(6,3),QevapHP] = evaporator(stateSteam(6,2));
QsupHP=stateSteam(3).h-stateSteam(6,3).h;
%no superheater function because state(3) is already define !

%LP steamflow :
[stateSteam(2,3),QevapLP] = evaporator(stateSteam(2,2));
TmaxLP=stateSteam(6,2).T+dTpinch;
[stateSteam(4),QsupLP] = superheater(stateSteam(2,3),TmaxLP,dTpinch);

% GAS STATE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% stateNumberGas = 4;
% stateGas(stateNumberGas).p = []; %preallocation
% stateGas(stateNumberGas).T = [];
% stateGas(stateNumberGas).x = [];
% stateGas(stateNumberGas).h = [];
% stateGas(stateNumberGas).s = [];
% stateGas(stateNumberGas).e = [];
% 
% for i=1:stateNumberSteam-1
%     stateGas(i).p = [];
%     stateGas(i).T = [];
%     stateGas(i).x = [];
%     stateGas(i).h = [];
%     stateGas(i).s = [];
%     stateGas(i).e = [];
% end


TgEcoLP=stateSteam(2,2).T+dTpinch
hGecoLP = fgProp('h',TgEcoLP+273.17,nM)

TgEcoHP=stateSteam(6,2).T+dTpinch
hGecoHP = fgProp('h',TgEcoHP+273.15,nM)




%% FLOW RATE CALCULATION
% h4g=2000;
% hgLP=700;
% hgHP=1500;


function F = flowRate(x)
h2prime2=stateSteam(2,3).h;
h2prime=stateSteam(2,2).h;
h3=stateSteam(3).h;
h4=stateSteam(4).h;
h6=stateSteam(6,1).h;
h6prime=stateSteam(6,2).h;
h6prime2=stateSteam(6,3).h;
F=[mGas*(hGecoHP-hGecoLP)-(x(1)*(h2prime2-h2prime)+x(1)*(h4-h2prime2)+x(2)*(h6prime-h6));
   mGas*(stateGas(4).h-hGecoHP)-(x(2)*(h3-h6prime));];
end
x0 = [10,30];  % Make a starting guess at the solution
%options = optimoptions('fsolve','Display','iter'); % Option to display output
[x,~] = fsolve(@flowRate,x0); % Call solver
%[x,~] = fsolve(@(x) flowRate(x,state), x0);
mSteamLP=x(1);
mSteamHP=x(2);
mSteamTot=mSteamLP+mSteamHP;

%% EXHAUST TEMPERATURE CALCULATION
%works for kelvin 
hGexhaust=mSteamTot*(stateSteam(2,1).h-stateSteam(2,2).h)/mGas+hGecoLP;
hGuess = fgProp('h',50+273.15,nM)

Tsup=TgEcoLP+273.15
Tinf=Ta;
r = 1;
n=1;
nmax=50;
while abs(r) > 0.01 && n<nmax
    Tguess = (Tsup+Tinf)/2
    fprintf('Tguess = %f\n',Tguess)
    hGuess = fgProp('h',Tguess,nM)
    r = hGexhaust-(hGuess)
    if r < 0
        Tsup = Tguess;
    elseif r > 0
        Tinf = Tguess;
    else
        break
    end
    n=n+1
end
Texhaust=Tguess-273.15;

%% stateSteam display in table
% M = (reshape(struct2array(stateSteam),6,10))';
% T = array2table(M,'VariableNames',{'p','T','x','h','s','e'});
% length(struct2array(stateSteam))
% % stateIndex = cell(stateNumber+3*nF+2*nR,1);
% % for i = 1:length(stateIndex)
% %     if i<5
% %         stateIndex(i) = {num2str(i)};
% %     elseif 5<=i && i<5+2*nR
% %         if mod(i,2)~=0
% %             stateIndex(i) = {[num2str((5+i)/2) ',' nums2str((i-3)/2)]};
% %         else
% %             stateIndex(i) =
% %         end
% %     end
% % end
% disp(T)
% fprintf('\n')
% %fprintf('Wmcy = %f kJ/kg\n\n',Wmcy)

%% T-Q diagram
%HRSG_q=[stateSteam(3).h, stateSteam(6,3).h, stateSteam(6,2).h, stateSteam(4).h,stateSteam(2,3).h, stateSteam(2,2).h,stateSteam(2,1).h]
mSteamHP=50;
mSteamLP=8;
Q=[0,mSteamHP*QsupHP,mSteamHP*QevapHP,mSteamHP*QecoHP+mSteamLP*QsupLP,mSteamLP*QevapLP,(mSteamLP+mSteamHP)*QecoLP];
Qtot=sum(Q);
for i=1:length(Q)
    Qtransfer(i)=sum(Q(1:i));
end
HRSGt=[stateSteam(3).T, stateSteam(6,3).T, stateSteam(6,2).T,stateSteam(2,3).T, stateSteam(2,2).T,stateSteam(2,1).T];
%plot(Qtransfer/Qtot, HRSGt);

%% DIAGRAMS : TS and HS
%Ts_diagramCombined(stateSteam,eta_siP,eta_siT)

function x = fgProp(prop,T,nM)
    T0 = 273.15;
        switch prop
            case 'h'
                base = [enthalpy('CO2',T) enthalpy('H2O',T) enthalpy('O2',T) enthalpy('N2',T)];
                base0 = [enthalpy('CO2',T0) enthalpy('H2O',T0) enthalpy('O2',T0) enthalpy('N2',T0)];
            case 's'
                base = [entropy('CO2',T) entropy('H2O',T) entropy('O2',T) entropy('N2',T)];
                base0 = [entropy('CO2',T0) entropy('H2O',T0) entropy('O2',T0) entropy('N2',T0)];
        end
        x = (base - base0)*nM';
    end
end


