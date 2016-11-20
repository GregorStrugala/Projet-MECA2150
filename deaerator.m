function [stateO, ExLoss] = deaerator(stateBleeds, stateI, stateII)
%DEAERATOR computes the state variation after a de-gazing and a heat
%exchange.
%   stateO = DEAERATOR(stateBleed,stateI,stateII) returns a struct
%   containing the values of the state variables at the output of the
%   deaerator. The pressure of stateO is the same as that of stateI.
%
%   [stateO, ExLoss] = DEAERATOR(stateBleeds, stateI, stateII) also returns
%   the exergetic loss due to the heat transfer.

%% robustness %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin==0 || nargin==1 % Check for presence of inputs.
    msgID = 'DEAERATOR:NoState';
    msg = 'Feeds and input state must be specified.';
    baseException = MException(msgID,msg);
    throw(baseException)
elseif nargout==2 && nargin==2
    msgID = 'DEAERATOR:NoState';
    msg = 'stateII must be specified in order to compute exergetic losses';
    baseException = MException(msgID,msg);
    throw(baseException)
end

%% Check for correct input bleed %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Tsat = 0;
i = 0;
while Tsat < 120 % the saturation temperature must be higher than 120°C
    i = i+1;
    Tsat = XSteam('Tsat_p',stateBleeds(i).p);
end
% at the end of the loop, Tsat is the saturation temperature and i is the
% index of the corresponding bleed.
To = Tsat; % ?

%% State calculation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stateO.p = stateI.p;
stateO.T = To;
stateO.x = 0;
stateO.h = XSteam('hL_T',To);
stateO.s = XSteam('sL_T',To);

%% Exergetic analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargout==2 % we compute the exergy only if needed.
eO = exergy(stateO);
eI = exergy(stateI);
eII = exergy(stateII);
ExLoss = eO - ( eI + eII );
end
end