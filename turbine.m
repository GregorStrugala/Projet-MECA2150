function [stateO,Wmov,ExLoss,eta_turbex] = turbine(stateI,Tcond,efficiency)
%TO BE REWRITTEN IN CASE OF X IS NOT DEFINE !!!
%TURBINE computes the state variation after an expansion through a turbine.
%   stateO = TURBINE(stateI,Tcond,efficiency) finds the new values of the
%   state variables contained in stateI, where stateI is a struct with
%   fields {p,T,x,h,s}.The values of the state variable need to be
%   expressed in the units {bar,°C,-,kJ/kg,kJ/(kg*°C)}. (Here, only fields
%   p and T are mandatory, since they corresponds to the two variables used
%   to find the next state.)
%   Tcond is the temperature at which the condensation occurs.
%   efficiency is the isentropic efficency of the turbine. If no efficiency
%   is specified, it is automoatically set to 1, making the expansion
%   isnetropic.
%
%   [stateO,Wmov,ExLoss,eta_turbex] = TURBINE(stateI,Tcond,efficiency) also
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
        msgID = 'TURBINE:NoTcond';
        msg = 'Condensation temperature must be specified.';
        baseException = MException(msgID,msg);
        throw(baseException)
    case 2
        efficiency = 1;
end

%% State calculation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% known variables
Ti = stateI.T;%Tmax
pI = stateI.p;%steamPressure
pO = XSteam('psat_T',Tcond); %Attention robustesse !!! Pas vrai si x pas déf.

% Find sI and hI with tables
sI = XSteam('s_pT',pI,Ti);
hI = XSteam('h_pT',pI,Ti);

% Determine hOut using isentropic efficiency
sO_s = sI;
sO_v = XSteam('sV_p',pO); % saturated vapour entropy (in the tables)
sO_l = XSteam('sL_p',pO); % saturated liquid entropy
xO_s = (sO_s - sO_l)/(sO_v - sO_l);
hO_v = XSteam('hV_p',pO); % saturated vapour enthalpy (in the tables)
hO_l = XSteam('hL_p',pO); % saturated liquid enthalpy
hO_s = xO_s*hO_v + (1-xO_s)*hO_l;
W_s = hO_s - hI; % isentropical work
Wmov = efficiency*W_s; % Work done by the expansion
hO = hI + Wmov; % the work is the enthalpy variation

% We find the quality based on h2
xO = (hO-hO_l)/(hO_v - hO_l);
sO = xO*sO_v + (1-xO)*sO_l;

stateO.p = pO;
stateO.T = Tcond;
stateO.x = xO;
stateO.h = hO;
stateO.s = sO;

%% Exergetic Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eI=exergy(stateI);
eO=exergy(stateO);

eta_turbex=abs(Wmov/(eI-eO));

ExLoss = eO-eI; % Exergy loss due to irreversibilities in the turbine.
end