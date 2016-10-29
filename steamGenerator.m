function [stateO,Qh,Exloss] = steamGenerator(stateI,Tmax)
%STEAMGENERATOR computes the state variation after a superheating.
%   stateO = STEAMGENERATOR(stateI,Tmax) finds the new values of
%   the state variables contained in stateI, where stateI is a struct with
%   fields {p,T,x,h,s}. The values of the state variable need to be
%   expressed in the units {bar,°C,-,kJ/kg,kJ/(kg*°C)}. (Here, only fields
%   p, h and s are mandatory, since they corresponds to the variables used
%   to find the next state.)
%   Tmax is the temperature of the fluid at the end of the superheating.
%
%   [stateO,Qh,Exloss] = steamGenerator(stateI,Tmax) also returns the heat
%   provided to transform all the subcooled liquid water into superheated
%   vapour, and the exergetic loss due to heat transfer.

%X est le factor de perte de charge lors de l'apport de chaleur

%% Robustness %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch nargin % Check for correct inputs
    case 0
        msgID = 'STEAMGENERATOR:NoState';
        msg = 'Initial state must be specified.';
        baseException = MException(msgID,msg);
        throw(baseException)
    case 1
        msgID = 'FEEDPUMP:NoTmax';
        msg = 'Tmax must be specified.';
        baseException = MException(msgID,msg);
        throw(baseException)
end

T0 = 15; % reference temperature for exergy calculation [°C]

%% State calculation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pI = stateI.p;
Ti = stateI.T;
xI=stateI.x;
hI=stateI.h;
sI=stateI.s;

pO=pI;
To=Tmax;
xO=NaN;

hO=XSteam('h_pt',pO,To);
sO=XSteam('s_pt',pO,To);

stateO.p = pO;
stateO.T = To;
stateO.x = xO;
stateO.h = hO;
stateO.s = sO;

%% Energetic analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Qh = hO - hI; % heat provided at the hot source.

%% Exergetic analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Exloss = T0*(sO - sI); % Exergy loss due to heat transfer.
end