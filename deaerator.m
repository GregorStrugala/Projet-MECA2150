function [ stateO ] = deaerator( stateBleeds, stateI)
%DEAERATOR computes the state variation after a de-gazing and a heat
%exchange.
%   stateO = DEAERATOR(stateBleed) returns a struct containing the values
%   of the state variables at the output of the deaerator.

%% robustness %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin==0 || nargin==1 % Check for presence of inputs.
    msgID = 'DEAERATOR:NoState';
    msg = 'Feeds and input state must be specified.';
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
feedState = stateBleeds(i);

%% State calculation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end