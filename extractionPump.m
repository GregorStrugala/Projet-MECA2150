function[stateO]=extractionPump(stateI,X,pmax,eta_siP)
%EXTRACTIONPUMP computes the state variation after a compression by the extraction pump.
%   stateO = EXTRACTIONPUMP(stateI,X,eta_siP) finds the new values of
%   the state variables contained in stateI, where stateI is a struct with
%   fields {p,T,x,h,s}. The values of the state variable need to be
%   expressed in the units {bar,°C,-,kJ/kg,kJ/(kg*°C)}. (Here, only fields
%   h and s are mandatory, since they corresponds to the two variables used
%   to find the next state.)
%   X is the ratio of compression between the extraction pump and the feed
%   pump from p_initial and p_max= steam presssure at the turbine.
%   pmax is the pressure in the fluid after it has been compressed by the feed pump in the turbine inlet.
%   eta_siP is the isentropic efficiency of the pump. If no efficiency is
%   specified, it is automoatically set to 1, making the expansion
%   isentropic.
%
% Suffix s : isentropic pump
% Suffix / : non isentropic pump

%% Robustness %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch nargin % Check for correct inputs, set efficiency to 1 if none is specified.
    case 0
        msgID = 'EXTRACTIONPUMP:NoState';
        msg = 'Initial state must be specified.';
        baseException = MException(msgID,msg);
        throw(baseException)
    case 1
        msgID = 'EXTRACTIONPUMP:NoX';
        msg = 'The ratio of compression must be specified';
        baseException = MException(msgID,msg);
        throw(baseException)
    case 2
        msgID = 'EXTRACTIONPUMP:NoPmax';
        msg = 'The maximal pressure must be specified.';
        baseException = MException(msgID,msg);
        throw(baseException)
    case 3
        eta_siP = 1;
end

%% State calculation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pI = stateI.p;
Ti = stateI.T;
xI = stateI.x;
hI = stateI.h;
sI = stateI.s;

pO=X*pmax;%or state(2).p
xO=NaN;


% Isentropic compression
sO_s=sI;
To_s=XSteam('T_ps',pO,sO_s);
hO_s=XSteam('h_ps',pO,sO_s);

% Non isentropic compression %
%-> eta_siP = (h2s-h1)/(h2-h1)
hO=((hO_s-hI))/eta_siP+hI;
To=XSteam('T_ph',pO,hO);
sO=XSteam('s_ph',pO,hO);

stateO.p = pO;
stateO.T = To;
stateO.x = xO;
stateO.h = hO;
stateO.s = sO;

end