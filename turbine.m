function [stateO,Wmov,lossEn,lossEx] = turbine(stateI,pOut,eta_siT,turbineEfficiency)
%TO BE REWRITTEN IN CASE OF X IS NOT DEFINE !!!
%TURBINE computes the state variation after an expansion through a turbine.
%   stateO = TURBINE(stateI,Tcond,eta_siT) finds the new values of the
%   state variables contained in stateI, where stateI is a struct with
%   fields {p,T,x,h,s}.The values of the state variable need to be
%   expressed in the units {bar,�C,-,kJ/kg,kJ/(kg*�C)}. (Here, only fields
%   p and T are mandatory, since they corresponds to the two variables used
%   to find the next state.)
%   Tcond is the temperature at which the condensation occurs.
%   eta_siT is the isentropic efficency of the turbine. If no efficiency
%   is specified, it is automoatically set to 1, making the expansion
%   isnetropic.
%
%   [stateO,stateI] = TURBINE(stateI,Tcond,eta_siT) also returns the
%   completed input state. (Fields x, h and s do not need to contain a
%   value, as they are computed inside the function anyway.) This is useful
%   to get information about x, h and s at the initial state.
%
%   [~,~,Wmov,ExLoss,eta_turbex] = TURBINE(stateI,Tcond,efficiency) also
%   returns the work provided by the fluid to the turbine (Wmov) in
%   [kJ/kg], the exergetic loss, and the exergetic efficiency of the
%   turbine.

%% robustness %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch nargin % Check for correct inputs, set efficiency to 1 if none is specified.
    case 0
        msgID = 'TURBINE:NoState';
        msg = 'Initial state must be specified.';
        baseException = MException(msgID,msg);
        throw(baseException)
    case 1
        msgID = 'TURBINE:NoPout';
        msg = 'Output pression must be specified.';
        baseException = MException(msgID,msg);
        throw(baseException)
    case 2
        eta_siT = 1;
end

%% State calculation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% known variables
pI = stateI.p;%steamPressure
Ti = stateI.T;%Tmax
xI = stateI.x;
hI = stateI.h;
sI = stateI.s;
eI = stateI.e;

pO = pOut; %Attention robustesse !!! Pas vrai si x pas d�f.
%To = XSteam('Tsat_p',pO); pas assez robuste :)

% Find sI and hI with tables --> fait dans la fonction steamPowerPlant
%sI = XSteam('s_pT',pI,Ti);
%hI = XSteam('h_pT',pI,Ti);

% Determine hO using isentropic efficiency
sO_s=sI;
To_s=XSteam('T_ps',pO,sO_s);
hO_s=XSteam('h_ps',pO,sO_s);

% Non isentropic expansion %
%-> eta_siT = (h2-h1)/(h2s-h1)
hO = hI + eta_siT*(hO_s - hI);
To=XSteam('T_ph',pO,hO);
sO=XSteam('s_ph',pO,hO);

%determination of the quality
% sO_v = XSteam('sV_p',pO); % saturated vapour entropy (in the tables)
% sO_l = XSteam('sL_p',pO); % saturated liquid entropy
% xO_s = (sO_s - sO_l)/(sO_v - sO_l);

hO_v = XSteam('hV_p',pO); % saturated vapour enthalpy (in the tables)
hO_l = XSteam('hL_p',pO); % saturated liquid enthalpy

% hO_s = xO_s*hO_v + (1-xO_s)*hO_l;
% W_s = hO_s - hI; % isentropical work
% Wmov = eta_siT*W_s; % Work done by the expansion
% hO = hI + Wmov; % the work is the enthalpy variation

% We find the quality based on h2
xO = (hO-hO_l)/(hO_v - hO_l);
% if, necessaire pour le reHeating sinon on obtient un x > 1 :)
if xO>1
    xO=nan;
end

% sO = xO*sO_v + (1-xO)*sO_l;

stateO.p = pO;
stateO.T = XSteam('T_ph',pO,hO);
stateO.x = xO;
stateO.h = hO;
stateO.s = sO;


%% Energetic Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Wmov = hO-hI; % Work done by the expansion
lossEn=abs(Wmov*(1-turbineEfficiency));
%% Exergetic Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%eI=exergy(stateI);
eO=exergy(stateO);
stateO.e = eO;

%eta_turbex=abs(Wmov/(eI-eO));

%eta_turbex=Wmov/(eO-eI) --> losses = (1-eta_turbex)
lossEx = abs(eO-eI)-abs(Wmov); % Exergy loss due to irreversibilities in the turbine.
end