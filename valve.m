function[stateO]=valve(stateI,previousFeedHeater)
%VALVE computes the state variation after a valve expansion (isenthalpic expansion).
%   stateO = VALVE(stateI,state) finds the new values of
%   the state variables contained in stateI and state, where stateI (and state) is a struct with
%   fields {p,T,x,h,s}. The values of the state variable need to be
%   expressed in the units {bar,°C,-,kJ/kg,kJ/(kg*°C)}.
%  

%% Robustness %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch nargin % Check for correct inputs
    case 0
        msgID = 'VALVE:NoStateIN';
        msg = 'Initial state must be specified.';
        baseException = MException(msgID,msg);
        throw(baseException)
    case 1
        msgID = 'VALVE:NoState';
        msg = 'State must be specified.';
        baseException = MException(msgID,msg);
        throw(baseException)
end
%% state calculation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pI = stateI.p;
Ti = stateI.T;
xI = stateI.x;
hI = stateI.h;
sI = stateI.s;


hO=hI;
pO=previousFeedHeater.p;
To=previousFeedHeater.T;


sO=XSteam('s_ph',pO,hO);
xO=XSteam('x_ph',pO,hO);

stateO.p = pO;
stateO.T = To;
stateO.x = xO;
stateO.h = hO;
stateO.s = sO;
stateO.e = exergy(stateO);
end

