function [] = combinedCyclePowerPlant3P(deltaT,Triver,HPsteamPressure,dTpinch,dTapproach,PeGT)
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
CCPP=1;
% State calculations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Pe=225e3;
Ta=15;
Tf=1250;
r=15;
etaC=0.9;
etaT=0.9;
kcc=0.95;
kmec=0.015;
fuel='CH4';
%call to the gasTurbine function:
[stateGas,mGas,nM,gasTurbMecLoss,gasTurbCombLossEx,gasTurbCompLossEx,gasTurbLossEx] = gasTurbine(Pe,Ta,Tf,r,kcc,etaC,etaT,kmec,'[]',fuel);
stateGas(4).T
%efficiencies
eta_mec=0.954;
eta_gen=0.945;
eta_siT=0.89;
eta_siP=0.85;

%temperature of condensation
Tcond=Triver+deltaT;

% STEAM STATE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stateNumberSteam = 10;
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
stateSteam(10,1).p=HPsteamPressure;
stateSteam(10,2).p=HPsteamPressure;
stateSteam(10,2).T=XSteam('Tsat_p',HPsteamPressure);
stateSteam(10,3).p=HPsteamPressure;
stateSteam(10,3).T=XSteam('Tsat_p',HPsteamPressure);

stateSteam(1).T=Tcond;
stateSteam(1).p=XSteam('psat_T',Tcond);
stateSteam(7).T=Tcond;
stateSteam(7).p=stateSteam(1).p;

stateSteam(9,4).T=stateSteam(10,3).T;
stateSteam(6).T=stateSteam(10,3).T;

%definition of the state(3) : complete!
%ToGasTurbine=stateGas(4).T
ToGasTurbine=615;
stateGas(4).T
stateSteam(3).T=ToGasTurbine-dTapproach;
stateSteam(5).T=stateSteam(3).T;
stateSteam(3).p=HPsteamPressure;
stateSteam(3).x=nan;
stateSteam(3).s = XSteam('s_pT',HPsteamPressure,stateSteam(3).T);
stateSteam(3).h = XSteam('h_pT',HPsteamPressure,stateSteam(3).T);
stateSteam(3).e = exergy(stateSteam(3));

%Determination of the IPsteamPressure :
%we imposed xOturbine at 0.88
stateSteam(7).x=0.95;
%-> we can define completely du stateSteam(7)
stateSteam(7).h=XSteam('h_px',stateSteam(7).p,stateSteam(7).x);
stateSteam(7).s=XSteam('s_ph',stateSteam(7).p,stateSteam(7).h);
stateSteam(7).e=exergy(stateSteam(7));

%we proceed by iteration
pSupIP=HPsteamPressure;
pInfIP=stateSteam(7).p;
r = 1;
nmax=50;
n=0;
while abs(r) > 0.01 && n<nmax
    pGuessIP = (pSupIP+pInfIP)/2;
    %fprintf('pGuess = %f\n',pGuessIP);
    h7=stateSteam(7).h;
    h5=XSteam('h_pT',pGuessIP,stateSteam(5).T);
    h7s=XSteam('h_ps',stateSteam(7).p,XSteam('s_pT',pGuessIP,stateSteam(5).T));
    r=h7-(h5-eta_siT*(h5-h7s));
       if r > 0
        pSupIP = pGuessIP;
    elseif r < 0
        pInfIP = pGuessIP;
    else
        break
       end
    n=n+1;
end
IPsteamPressure=pGuessIP
stateSteam(5).p=IPsteamPressure;
stateSteam(5).h=XSteam('h_pT',IPsteamPressure,stateSteam(5).T);
stateSteam(5).s=XSteam('s_pT',IPsteamPressure,stateSteam(5).T);

%Determination of the LPsteamPressure :
pSupLP=stateSteam(5).p;
pInfLP=stateSteam(7).p;
r = 1;
nmax=50;
n=0;
while abs(r) > 0.01 && n<nmax
    pGuessLP = (pSupLP+pInfLP)/2;
    %fprintf('pGuessLP = %f\n',pGuessLP)
    h5=stateSteam(5).h;
    h6=XSteam('h_pT',pGuessLP,stateSteam(6).T);
    h6s=XSteam('h_ps',pGuessLP,stateSteam(5).s);
    r=h6-(h5-eta_siT*(h5-h6s));
       if r < 0
        pSupLP = pGuessLP;
    elseif r > 0
        pInfLP = pGuessLP;
    else
        break
       end
    n=n+1;
end
LPsteamPressure=pGuessLP
stateSteam(6).p=LPsteamPressure;


%We begin the cycle at the state(3)
%HP and IP part:
pOut = stateSteam(7).p;
pRatio=IPsteamPressure/HPsteamPressure;
%reHeating function define steamState(4),(5),(7)
[stateSteam,WmovTurb,QreHeat,turbineLossEn,turbineLossEx]=reHeating(stateSteam,stateSteam(3),pRatio,pOut,eta_siT,eta_mec,eta_gen,0,1,CCPP);

%TOTAL steamflow :
[stateSteam(1),~,condenserLossEn,condenserLossEx] = condenser(stateSteam(7));
[stateSteam(2,1),Wop,feedPumpLossEn,feedPumpLossEx] = feedPump(stateSteam(1),LPsteamPressure,eta_siP,eta_mec);
[stateSteam(2,2),QecoLP,dExEcoLP] = economizer(stateSteam(2,1));

%IP steamflow :
[stateSteam(9,1),WopHP,pumpLossEnIP,pumpLossExHP] = feedPump(stateSteam(2,2),IPsteamPressure,eta_siP,eta_mec);
[stateSteam(9,2),QecoIP,dExEcoIP] = economizer(stateSteam(9,1));
[stateSteam(9,3),QevapIP,dExEvapIP] = evaporator(stateSteam(9,2));


%HP steamflow :
[stateSteam(10,1),WopHP,pumpLossEnIP,pumpLossExHP] = feedPump(stateSteam(9,2),HPsteamPressure,eta_siP,eta_mec);
[stateSteam(10,2),QecoIP,dExEcoIP] = economizer(stateSteam(10,1));
[stateSteam(10,3),QevapIP,dExEvapIP] = evaporator(stateSteam(10,2));
TmaxIP=stateSteam(10,3).T+dTpinch;
[stateSteam(9,4),QsupLP,dExSuperLP] = superheater(stateSteam(9,3),TmaxIP,dTpinch);

%LP steamflow :
[stateSteam(2,3),QevapLP,dExEvapLP] = evaporator(stateSteam(2,2));
TmaxLP=stateSteam(9,3).T+dTpinch;
[stateSteam(8),QsupLP,dExSuperLP] = superheater(stateSteam(2,3),TmaxLP,dTpinch);
TmaxLP=stateSteam(9,4).T+dTpinch;
[stateSteam(6),QsupLP,dExSuperLP] = superheater(stateSteam(8),TmaxLP,dTpinch);
%not necessary to compute out superheater for stateSteam(3). Already define


%state
state1=stateSteam(1)
state21=stateSteam(2,1)
state22=stateSteam(2,2)
state23=stateSteam(2,3)
state3=stateSteam(3)
state41=stateSteam(4,1)
state42=stateSteam(4,2)
state5=stateSteam(5)
state6=stateSteam(6)
state7=stateSteam(7)
state8=stateSteam(8)
state91=stateSteam(9,1)
state92=stateSteam(9,2)
state93=stateSteam(9,3)
state94=stateSteam(9,4)
state101=stateSteam(10,1)
state102=stateSteam(10,2)
state103=stateSteam(10,3)




%% DIAGRAMS : TS and HS
Ts_diagramCombined(stateSteam,eta_siP,eta_siT,'3P');
end