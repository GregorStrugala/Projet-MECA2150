function [stateO,Q,dExEvap] = evaporator(stateI)
%TO BE REWRITE CASE OF X IS NOT DEFINE !!!
%CONDENSER computes the state variation after an isohtermal ad isobaric
%condensation.
%   stateO = CONDENSER(stateI) finds the new values of the state variables
%   contained in stateI, where stateI is a struct with fields {p,T,x,h,s}.
%   (Here, only fields p and T are mandatory, since they corresponds to the
%   two variables used to find the next state.)
%   The values of the state variable need to be expressed in the units
%   {bar,°C,-,kJ/kg,kJ/(kg*°C)}.
%
%   [stateO,Qc] = CONDENSER(stateI) returns the next state AND the heat
%   extracted at the condenser, in [kJ/kg].
%
%   [stateO,Qc,ExLoss] = CONDENSER(stateI) returns the next state, the heat
%   extracted at the condenser in [kJ/kg], and the exergy loss, also in
%   [kJ/kg].

%% robustness %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin==0 % Check for correct inputs.
    msgID = 'ISOPTCONDENSATION:NoState';
    msg = 'Input state must be specified.';
    baseException = MException(msgID,msg);
    throw(baseException)
end


%% State calculation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pI = stateI.p;
Ti = stateI.T;
xI = stateI.x;
hI = stateI.h;
sI = stateI.s;
eI = stateI.e;

%if isnan(xI)
To=Ti;%more general

%else
%To = stateI.T; % isothermal transformation
%end

pO = pI; % isobaric transformation
%state.p(nextStage) = XSteam('psat_T',state.T(stage));


% The next state is saturated liquid:
sO = XSteam('sV_T',To);
hO = XSteam('hV_T',To);
xO = 1;

stateO.p = pO;
stateO.T = To;
stateO.x = xO;
stateO.h = hO;
stateO.s = sO;
eO=exergy(stateO);
stateO.e = eO;

Q=stateO.h-stateI.h;

%% Exergetic difference for the heated fluid
dExEvap=eO-eI;
end