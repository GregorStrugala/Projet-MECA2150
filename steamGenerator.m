function [Qh,Eloss] = steamGenerator(stateI,Tmax)
%STEAMGENERATOR Update the state after an isobaric vaporisation.
%   This MATLAB function has to be used together with a global variable
%   called state. Given a certain stage of variables [p,T,h,s,x], the
%   function computes the values of the next stage if the transformation is
%   an isobaric vaporisation (ie, a phase change) followed by an isobaric
%   superheating.
%
%   input args:
%           stage: integer corresponding to the index of the state
%           just before the expansion. The function will thus update the
%           state related to the index stage + 1, unless stage is the last
%           index of the cycle.
%
%       output args:
%           Qh: heat provided to transform all the subcooled liquid water
%           to superheated vapour.
%
%   [Qh,Eloss] = CONDENSER(stage)

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
    case 2
        eta_siP = 1;
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
Eloss = T0*(sO - sI); % Exergy loss due to heat transfer.
end

