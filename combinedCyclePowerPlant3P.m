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

% State calculations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Pe=160e6;
Ta=15+273;
Tf=1400+273;
r=15;
etaC=0.9;
etaT=0.9;
kcc=0.95;
kmec=0.015;
fuel='CH4';
%call to the gasTurbine function:
%[stateGas,mg,nM,MecLoss,CombLoss,CompLoss,TurbLoss] = gasTurbine(Pe,Ta,Tf,r,kcc,etaC,etaT,kmec,'ts',fuel);

%efficiencies
eta_mec=0.98;
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
pSupIP=stateSteam(3).p
pInfIP=stateSteam(7).p
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
IPstreamPressure=pGuessIP;
stateSteam(5).p=IPstreamPressure;
stateSteam(5).h=XSteam('h_pT',IPstreamPressure,stateSteam(5).T);
stateSteam(5).s=XSteam('s_pT',IPstreamPressure,stateSteam(5).T);

%Determination of the IPsteamPressure :
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
LPsteamPressure=pGuessLP;
stateSteam(6).p=IPstreamPressure;


%PLOT
% state1=stateSteam(1)
% state3=stateSteam(3)
% state7=stateSteam(7)
state5=stateSteam(5)
stateSteam(6)

end