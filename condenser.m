function [Qc] = condenser(stage)
%TO BE REWRITE CASE OF X IS NOT DEFINE !!!

%CONDENSER Update the state after an isobaric and isothermal
%condensation.
%   This MATLAB function has to be used together with a global variable
%   called state. Given a certain stage of variables [p,T,h,s,x], the
%   function computes the values of the next stage if the transformation is
%   an isobaric and isothermal condensation (ie, a phase change).
%
%       input args:
%           stage: integer corresponding to the index of the state
%           just before the condensation. The function will thus update the
%           state related to the index stage + 1, unless stage is the last
%           index of the cycle.
%
%       output args:
%           Qc: heat extracted at the condenser to transform all the
%           vapour into saturated liquid water.
%
%   Qc = CONDENSER(stage)

global state

if nargin==0 % Check for correct inputs.
    msgID = 'ISOPTCONDENSATION:NoStage';
    msg = 'Initial stage must be specified.';
    baseException = MException(msgID,msg);
    throw(baseException)
end

% Check if the stage is the last one of the cycle, then we have to go to
% the beginning (first stage).
stageNumber = length(state.p);
if stage < stageNumber
    nextStage = stage + 1;
else
    nextStage = 1;
end
T2 = state.T(stage); % isothermal transformation
state.p(nextStage) = state.p(stage); % isobaric transformation
%state.p(nextStage) = XSteam('psat_T',state.T(stage));


% The next state is saturated liquid:
state.x(nextStage) = 0;
h2 = XSteam('hL_T',T2);
Qc = h2 - state.h(stage); % Function output: heat extracted at the condenser
state.h(nextStage) = h2; % Update state
state.s(nextStage) = XSteam('sL_T',T2);

end