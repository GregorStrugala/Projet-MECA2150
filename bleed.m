function[stateO]=purge(hO,stateI,eta_siT)
%PURGE computes the state variation after the steam extraction in the turbine.
%   stateO = PURGE(stateI,eta_siT) finds the new values of
%   the state variables contained in stateI, where stateI is a struct with
%   fields {p,T,x,h,s}. The values of the state variable need to be
%   expressed in the units {bar,°C,-,kJ/kg,kJ/(kg*°C)}. (Here, only fields
%   h and s are mandatory, since they corresponds to the two variables used
%   to find the next state.)
%   eta_siT is the isentropic efficiency of the turbine. If no efficiency is
%   specified, it is automatically set to 1, making the expansion
%   isentropic.
%

% Suffix s : isentropic pump
% Suffix / : non isentropic pump

%% Robustness %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch nargin % Check for correct inputs, set efficiency to 1 if none is specified.
    case 0
        msgID = 'PURGE:NoState';
        msg = 'Initial state must be specified.';
        baseException = MException(msgID,msg);
        throw(baseException)
    case 2
        eta_siT = 1;
end

%% State calculation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% pI = stateI.p;
% Ti = stateI.T;
% xI = stateI.x;
% hI = stateI.h;
% sI = stateI.s;

%hO=abs(state(4).h+state(3).h)/(n+1); %should be more general !

hO_s=(hO-stateI.h)/eta_siT+stateI.h;% eta_si = Wm/Wm_s
sO_s=stateI.s;
pO_s=XSteam('p_hs',hO_s,sO_s);

pO=pO_s;
sO=XSteam('s_ph',pO,hO);
To=XSteam('T_hs',hO,sO);
xO=nan;

stateO.p = pO;
stateO.T = To;
stateO.x = xO;
stateO.h = hO;
stateO.s = sO;

end