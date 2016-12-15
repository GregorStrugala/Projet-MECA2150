function [] = combinedCyclePowerPlant3P(deltaT,Triver,HPsteamPressure,dTpinch,dTapproach,xOturbineLP,Ta,Tf,fuel,PeGT,diagrams)
close all;
%COMBINEDCYCLEPOWERPLANT3P characterises a power combined cycle with 3
%pressure levels
%   [] = COMBINEDCYCLEPOWERPLANT3P(deltaT,Triver,HPsteamPressure,dTpinch,dTapproach,Ta,Tf,fuel,PeGT,diagrams) displays state, ts-hs-tq diagram and energy
%   and exergy charts for the given parameters.
%   +-------- Mandatory parameters --------+ +--- Optionnal parameters ---+
%   |                                      | |                            |
%   |   Pe: power produced [kW]            | |  etaC: polytropic          |
%   |   Ta: temperature of the input air,  | |        efficiency of the   |
%   |       in °C.                         | |        compressor          |
%   |   Tf: Temperature at the output      | |  etaT: polytropic          |
%   |       of the combustion chamber.     | |        efficiency of the   |
%   |   r: compression pressure ratio.     | |        turbine             |
%   |   kcc: combustion chamber pressure   | +----- Default value = 1 ----+
%   |        ratio.                        | |                            |
%   |                                      | |  kmec: mechanical          |
%   +--------------------------------------+ |        efficiency          |
%                                            +----- Default value = 0 ----+
%                                            |                            |
%                                            | fuel: string containing the|
%                                            | fuel used for the comb-    |
%                                            | ustion (see available ones |
%                                            | in combustion function)    |
%                                            +--- Default value = 'CH4' --+
%                                            |                            |
%                                            |  diagrams: string cell     |
%                                            |  array that says which     |
%   'StateTable','ts','hs','EnPie','ExPie' <-|  diagrams should be        |
%                                            |  displayed                 |
%                                            +-Default value='StateTable'-+

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

CCPP=1;%for the reHeating function
% State calculations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r=15;
etaC=0.9;
etaT=0.9;
kcc=0.95;
kmec=0.015;

%call to the gasTurbine function:
[stateGas,mGas,nM,GTmecLoss,GTcombLossEx,GTcompLossEx,GTturbLossEx] = gasTurbine(PeGT,Ta,Tf,r,kcc,etaC,etaT,kmec,{'[]'},fuel);

%efficiencies
eta_mec=0.954;
eta_gen=0.945;
eta_siT=0.88;
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
%stateGas(4).T=615;
ToGasTurbine=stateGas(4).T;

stateSteam(3).T=ToGasTurbine-dTapproach;
stateSteam(5).T=stateSteam(3).T;
stateSteam(3).p=HPsteamPressure;
stateSteam(3).x=nan;
stateSteam(3).s = XSteam('s_pT',HPsteamPressure,stateSteam(3).T);
stateSteam(3).h = XSteam('h_pT',HPsteamPressure,stateSteam(3).T);
stateSteam(3).e = exergy(stateSteam(3));

%Determination of the IPsteamPressure :
%we imposed xOturbine at
stateSteam(7).x=xOturbineLP;
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
IPsteamPressure=pGuessIP;
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
LPsteamPressure=pGuessLP;
stateSteam(6).p=LPsteamPressure;


%We begin the cycle at the state(3)
%HP and IP part:
pOut = stateSteam(7).p;
pRatio=IPsteamPressure/HPsteamPressure;
%reHeating function define steamState(4),(5),(7)
[stateSteam,WmovHP,QreHeatHP,turbineLossEnHP,turbineLossExHP]=reHeating(stateSteam,stateSteam(3),pRatio,pOut,eta_siT,eta_mec,eta_gen,0,1,CCPP);


%TOTAL steamflow :
[stateSteam(1),~,condenserLossEn,condenserLossEx] = condenser(stateSteam(7));
[stateSteam(2,1),Wop,feedPumpLossEn,feedPumpLossEx] = feedPump(stateSteam(1),LPsteamPressure,eta_siP,eta_mec);
[stateSteam(2,2),QecoLP,dExEcoLP] = economizer(stateSteam(2,1));

%IP steamflow :
[stateSteam(9,1),WopIP,pumpLossEnIP,pumpLossExIP] = feedPump(stateSteam(2,2),IPsteamPressure,eta_siP,eta_mec);
[stateSteam(9,2),QecoIP,dExEcoIP] = economizer(stateSteam(9,1));
[stateSteam(9,3),QevapIP,dExEvapIP] = evaporator(stateSteam(9,2));


%HP steamflow :
[stateSteam(10,1),WopHP,pumpLossEnHP,pumpLossExHP] = feedPump(stateSteam(9,2),HPsteamPressure,eta_siP,eta_mec);
[stateSteam(10,2),QecoHP,dExEcoHP] = economizer(stateSteam(10,1));
[stateSteam(10,3),QevapHP,dExEvapHP] = evaporator(stateSteam(10,2));
QsupHP=stateSteam(3).h-stateSteam(10,3).h;

%superheater IP
TmaxIP=stateSteam(10,3).T+dTpinch;
[stateSteam(9,4),QsupIP,dExSupIP] = superheater(stateSteam(9,3),TmaxIP,dTpinch);
%reheating for the IP steamFlow
QreHeatIP=stateSteam(5).h-stateSteam(9,4).h;

%LP steamflow :
[stateSteam(2,3),QevapLP,dExEvapLP] = evaporator(stateSteam(2,2));
TmaxLP=stateSteam(9,3).T+dTpinch;
[stateSteam(8),QsupLP1,dExSupLP1] = superheater(stateSteam(2,3),TmaxLP,dTpinch);
TmaxLP=stateSteam(9,4).T+dTpinch;
[stateSteam(6),QsupLP2,dExSupLP2] = superheater(stateSteam(8),TmaxLP,dTpinch);

%expansion in the steam turbine
%LP
[~,WmovLP,turbineLossEnLP,turbineLossExLP] = turbine(stateSteam(6),stateSteam(1).p,eta_siT,eta_mec);
%IP
[~,WmovIP,turbineLossEnIP,turbineLossExIP] = turbine(stateSteam(5),stateSteam(1).p,eta_siT,eta_mec);

%Work done over a cycle
steamWmov=[WmovLP,WmovIP,WmovHP];
%not necessary to compute out superheater for stateSteam(3). Already define

steamTurbineLossEn=[turbineLossEnLP,turbineLossEnIP,turbineLossEnHP];
steamTurbineLossEx=[turbineLossExLP,turbineLossExIP,turbineLossExHP];

% GAS STATE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

TgEcoLP=stateSteam(2,2).T+dTpinch;
hGecoLP = fgProp('h',TgEcoLP+273.17,nM);

TgEcoIP=stateSteam(9,2).T+dTpinch;
hGecoIP = fgProp('h',TgEcoIP+273.15,nM);

TgEcoHP=stateSteam(10,2).T+dTpinch;
hGecoHP = fgProp('h',TgEcoHP+273.15,nM);

%% FLOW RATE CALCULATION

function F = flowRate(x)
h2p=stateSteam(2,2).h;
h3=stateSteam(3).h;
h4=stateSteam(4).h;
h5=stateSteam(5).h;
h8=stateSteam(8).h;
h9=stateSteam(9,1).h;
h9p=stateSteam(9,2).h;
h94=stateSteam(9,4).h;
h10=stateSteam(10,1).h;
h10p=stateSteam(10,2).h;

F=[mGas*(hGecoIP-hGecoLP)-((x(3)+x(2))*(h9p-h9)+x(1)*(h8-h2p));
   mGas*(hGecoHP-hGecoIP)-(x(3)*(h10p-h10)+x(2)*(h94-h9p)+x(1)*(h6-h8));
   mGas*(stateGas(4).h-hGecoHP)-(x(3)*(h3-h10p+h5-h4)+x(2)*(h5-h94));];
end

x0 = [10,10,70];  % Make a starting guess at the solution
%options = optimoptions('fsolve','Display','iter'); % Option to display output
[x,~] = fsolve(@flowRate,x0); % Call solver

mSteamLP=x(1);
fprintf('mSteamLP = %f\n',x(1))
mSteamIP=x(2);
fprintf('mSteamIP = %f\n',x(2))
mSteamHP=x(3);
fprintf('mSteamHP = %f\n',x(3))
mSteamTot=mSteamLP+mSteamIP+mSteamHP;
fprintf('mSteamTot = %f\n',x(1)+x(2)+x(3))

%% EXHAUST TEMPERATURE CALCULATION
hGexhaust=mSteamTot*(stateSteam(2,1).h-stateSteam(2,2).h)/mGas+hGecoLP;

Tsup=TgEcoLP;
Tinf=Ta;
r=1;
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
if strcmp(diagrams,'all')
    all = 1;
else
    all = 0;
end

% State table
if any(ismember('StateTable',diagrams))||all
M = (reshape(struct2array(stateSteam),6,18))';
T = array2table(M,'VariableNames',{'p','T','x','h','s','e'});
disp(T)
fprintf('\n')
end


% T-Q diagram 
if any(ismember('tq',diagrams))||all
% %HRSG_q=[stateSteam(3).h, stateSteam(6,3).h, stateSteam(6,2).h, stateSteam(4).h,stateSteam(2,3).h, stateSteam(2,2).h,stateSteam(2,1).h]
% mSteamHP=80;
% mSteamIP=12;
% mSteamLP=10;
Qsteam=[0,(mSteamHP*(QsupHP+QreHeatHP)+mSteamIP*(QreHeatIP)),(mSteamHP*QevapHP),(mSteamLP*QsupLP2+mSteamIP*QsupIP+mSteamHP*QecoHP),(mSteamIP*QevapIP),((mSteamTot-mSteamLP)*QecoIP+mSteamLP*QsupLP1),(mSteamLP*QevapLP),(mSteamTot*QecoLP)];
QsteamTot=sum(Qsteam);
QsteamTransfer=zeros(1,length(Qsteam));
for i=1:length(Qsteam)
    QsteamTransfer(i)=sum(Qsteam(1:i));
end
Tgas=[stateGas(4).T,TgEcoHP,TgEcoIP,TgEcoLP,TgExhaust];
HRSGt=[stateSteam(3).T, stateSteam(10,3).T, stateSteam(10,2).T,stateSteam(9,3).T, stateSteam(9,2).T,stateSteam(2,3).T,stateSteam(2,2).T,stateSteam(2,1).T];

%normalized T-Q diagram
plot(QsteamTransfer/QsteamTot, HRSGt);
hold on 
plot([0,QsteamTransfer(3)/QsteamTot, QsteamTransfer(5)/QsteamTot,QsteamTransfer(7)/QsteamTot,1],Tgas);

%no normalized T-Q diagram
% plot(QsteamTransfer, HRSGt);
% hold on 
% plot([0,QsteamTransfer(3), QsteamTransfer(5),QsteamTransfer(7),QsteamTransfer(8)],Tgas);
end


% T-S Diagram
if any(ismember('ts',diagrams))||all
Ts_diagramCombined(stateSteam,eta_siP,eta_siT,'3P');
end

% H-S Diagram
if any(ismember('hs',diagrams))||all
    
end

%% Energetic Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Energy pie chart
if any(ismember('EnPie',diagrams))||all
%definition of losses
mecLoss=GTmecLoss+steamTurbineLossEn*x'+mSteamTot*feedPumpLossEn+(mSteamTot-mSteamLP)*pumpLossEnIP+mSteamHP*pumpLossEnHP;
condenserLossEn=mSteamTot*condenserLossEn;
chimneyLoss=mGas*abs(stateGas(1).h-hGexhaust);
lossEn=[mecLoss,condenserLossEn,chimneyLoss];
PeST=(abs(steamWmov*x'-(mSteamTot*Wop+(mSteamTot-mSteamLP)*WopIP+mSteamHP*WopHP)))*eta_mec;
%pie
figure(1);
h = pie([PeGT,PeST,lossEn]);
hText = findobj(h,'Type','text'); % text object handles
percentValues = get(hText,'String'); % percent values
txt = {'GT effective power ';'ST effective power';'Mechanical losses ';'Condenser loss ';'Chimney loss '};
combinedtxt = strcat(txt,percentValues);
set(hText,{'String'},combinedtxt);
legend(txt);
end

%% Exergetic Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Exergy pie chart
if any(ismember('ExPie',diagrams))||all
%definition of lossex
rotorIrr=GTcompLossEx+GTturbLossEx+steamTurbineLossEx*x'+mSteamTot*feedPumpLossEx+(mSteamTot-mSteamLP)*pumpLossExIP+mSteamHP*pumpLossExHP;
condenserLossEx=mSteamTot*condenserLossEx;
chimneyLossEx=mGas*eGexhaust;

dExReHeatIP=abs(stateSteam(5).e-stateSteam(9,4).e);
dExReHeatHP=abs(stateSteam(6).e-stateSteam(4).e);
dExSupHP=abs(stateSteam(3).e-stateSteam(10,3).e);
heatedFluidExergy=mSteamTot*(dExEcoLP)+(mSteamTot-mSteamLP)*(dExEcoIP)+mSteamLP*(dExEvapLP+dExSupLP1+dExSupLP2)+mSteamIP*(dExEvapIP+dExSupIP+dExReHeatIP)+mSteamHP*(dExEcoHP+dExEvapHP+dExSupHP+dExReHeatHP);
transLossEx=mGas*(stateGas(4).e-eGexhaust)-(heatedFluidExergy);
lossEx=[mecLoss,condenserLossEx,rotorIrr,chimneyLossEx,transLossEx,GTcombLossEx];
figure(2);
h = pie([PeGT,PeST,lossEx]);
hText = findobj(h,'Type','text'); % text object handles
percentValues = get(hText,'String'); % percent values
txt = {'GT effective power ';'ST effective power';'Mechanical losses ';'Condenser loss ';'Rotor unit irreversibilities ';'Chimney loss ';'Heat transfer irreversibilities ';'Combustion irreversibilities '};
combinedtxt = strcat(txt,percentValues);
set(hText,{'String'},combinedtxt);
legend(txt);
end

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

% %state
% state1=stateSteam(1)
% state21=stateSteam(2,1)
% state22=stateSteam(2,2)
% state23=stateSteam(2,3)
% state3=stateSteam(3)
% state41=stateSteam(4,1)
% state42=stateSteam(4,2)
% state5=stateSteam(5)
% state6=stateSteam(6)
% state7=stateSteam(7)
% state8=stateSteam(8)
% state91=stateSteam(9,1)
% state92=stateSteam(9,2)
% state93=stateSteam(9,3)
% state94=stateSteam(9,4)
% state101=stateSteam(10,1)
% state102=stateSteam(10,2)
% state103=stateSteam(10,3)