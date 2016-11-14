function [stateO,Wop,eO,pumpLoss,Exloss] = feedPump(stateI,steamPressure,eta_siP,pumpEfficiency)
%FEEDPUMP computes the state variation after a compression.
%   stateO = FEEDPUMP(stateI,steamPressure,eta_siP) finds the new values of
%   the state variables contained in stateI, where stateI is a struct with
%   fields {p,T,x,h,s}. The values of the state variable need to be
%   expressed in the units {bar,°C,-,kJ/kg,kJ/(kg*°C)}. (Here, only fields
%   h and s are mandatory, since they corresponds to the two variables used
%   to find the next state.)
%   SteamPressure is the pressure in the fluid after it has been compressed.
%   eta_siP is the isentropic efficiency of the pump. If no efficiency is
%   specified, it is automatically set to 1, making the expansion
%   isentropic.
%
%   [stateO,Wop,Exloss] = FEEDPUMP(stateI,steamPressure,eta_siP) also
%   returns the work provided by the pump to the fluid (Wop) in
%   [kJ/kg] and the exergetic loss.
%
% Suffix s : isentropic pump
% Suffix / : non isentropic pump

%% Robustness %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch nargin % Check for correct inputs, set efficiency to 1 if none is specified.
    case 0
        msgID = 'FEEDPUMP:NoState';
        msg = 'Initial state must be specified.';
        baseException = MException(msgID,msg);
        throw(baseException)
    case 1
        msgID = 'FEEDPUMP:NoSteamPressure';
        msg = 'steamPressure must be specified.';
        baseException = MException(msgID,msg);
        throw(baseException)
    case 2
        eta_siP = 1;
end

%% State calculation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pI = stateI.p;
Ti = stateI.T;
xI = stateI.x;
hI = stateI.h;
sI = stateI.s;


T0=15;

xO=NaN;

% Isentropic compression
sO_s=sI;
pO=steamPressure;%p 110-113 Meca1855
To_s=XSteam('T_ps',pO,sO_s);
hO_s=XSteam('h_ps',pO,sO_s);

% Non isentropic compression %
%-> eta_siP = (h2s-h1)/(h2-h1)
hO=((hO_s-hI))/eta_siP+hI;
To=XSteam('T_ph',steamPressure,hO);
sO=XSteam('s_ph',pO,hO);

stateO.p = pO;
stateO.T = To;
stateO.x = xO;
stateO.h = hO;
stateO.s = sO;

%% Energetic analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Wop = hO-hI; % work done by the pump, it should be positive
pumpLoss=Wop*(1-pumpEfficiency)/pumpEfficiency;

%% Exergetic analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eI=exergy(stateI);
eO=exergy(stateO);

Exloss = eO - eI; % Exergy loss due to irreversibilities in the pump.
end