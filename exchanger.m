function [stateO] = exchanger(stateI,Tmax,dTpinch)
%EXCHANGER computes the state variation after that the fluid is passing
%through the exchanger.
%   stateO = EXCHANGER(stateI,dT) finds the new values of
%   the state variables contained in stateI, where stateI is a struct with
%   fields {p,T,x,h,s}. The values of the state variable need to be
%   expressed in the units {bar,°C,-,kJ/kg,kJ/(kg*°C)}. (Here, only fields
%   h and s are mandatory, since they corresponds to the two variables used
%   to find the next state.)
%   dT is the temperature difference before and after the exchanger

%% Robustness %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch nargin % Check for correct inputs, set efficiency to 1 if none is specified.
    case 0
        msgID = 'EXCHANGER:NoState';
        msg = 'Initial state must be specified.';
        baseException = MException(msgID,msg);
        throw(baseException)
    case 1
        msgID = 'EXCHANGER:NoDifferenceOfTemperature';
        msg = 'dT must be specified.';
        baseException = MException(msgID,msg);
        throw(baseException)
end
%% State calculation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pI = stateI.p;
Ti = stateI.T;
xI = stateI.x;
hI = stateI.h;
sI = stateI.s;

pO=pI;
To=Tmax-dTpinch;
fprintf('\npO = %f\nTo = %f\n',pO,To)
hO=XSteam('h_pt',pO,To);
sO=XSteam('s_pt',pO,To);
xO=nan;

stateO.p = pO;
stateO.T = To;
stateO.x = xO;
stateO.h = hO;
stateO.s = sO;
stateO.e = exergy(stateO);
end

