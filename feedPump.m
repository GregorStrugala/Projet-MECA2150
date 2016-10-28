function [stateO,Wop,Exloss] = feedPump(stateI,steamPressure,eta_siP)
%FEEDPUMP Update the state after a compression of specified isentropic
%efficiency.
%   This MATLAB function has to be used together with a global variable
%   called state. Given a certain step of variables [p,T,h,s,x], the
%   function computes the values of the next step if the transformation is
%   a compression achieved by a pump whose isentropic efficiency has to be
%   given as argument.
%
%   input args:
%           stage: integer corresponding to the index of the state
%           just before the compression. The function will thus update the
%           state related to the index stage+1, unless stage is the last
%           index of the cycle.
%
%           eta_siP: isentropic efficiency of the pump.
%
%   output args:
%       Wp: work done by the pump on the fluid, in [kJ/kg].
%
%       Eloss: exergy loss in the pump, in [kJ/kg].
%
%   [Wp,Eloss] = FEEDPUMP(stage,eta_siP)

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
sI=stateI.s;
hI=stateI.h;
xI=stateI.x;


T0=15;

xO=NaN;

% Isentropic compression
sO_s=sI;
To_s=XSteam('T_ps',steamPressure,sO_s);
hO_s=XSteam('h_ps',steamPressure,sO_s);

% Non isentropic compression %
%-> eta_siP = (h2s-h1)/(h2-h1)
hO=((hO_s-hI))/eta_siP+hI;
pO=steamPressure;%p 110-113 Meca1855
To=XSteam('T_ph',steamPressure,hO);
sO=XSteam('s_ph',pO,hO);

stateO.p = pO;
stateO.T = To;
stateO.s = sO;
stateO.h = hO;
stateO.x = xO;

%% Energetic analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Wop = hO-hI; % work done by the pump, it should be positive

%% Exergetic analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eI=exergy(stateI);
eO=exergy(stateO);

Exloss = T0*(sO - sI); % Exergy loss due to irreversibilities in the pump.
end

