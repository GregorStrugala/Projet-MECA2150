function [Qh,Exloss] = steamGenerator(stateI,Tmax)
%STEAMGENERATOR computes the state variation after a superheating.
%   [Qh,Exloss] = steamGenerator(stateI,Tmax) returns the heat
%   provided to transform all the subcooled liquid water into superheated
%   vapour, and the exergetic loss due to heat transfer.

%X est le factor de perte de charge lors de l'apport de chaleur

%% Robustness %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch nargin % Check for correct inputs, set efficiency to 1 if none is specified.
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
sI=stateI.s;
hI=stateI.h;
xI=stateI.x;

pO=pI;
To=Tmax;
xO=NaN;

hO=XSteam('h_pt',pO,To);
sO=XSteam('s_pt',pO,To);

%% Energetic analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Qh = hO - hI; % heat provided at the hot source.

%% Exergetic analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Exloss = T0*(sO - sI); % Exergy loss due to heat transfer.
end