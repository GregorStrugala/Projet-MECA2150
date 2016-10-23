function [Qh,Eloss] = steamGenerator(stage)
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

global state
%X est le factor de perte de charge lors de l'apport de chaleur

% Check if the stage is the last one of the cycle, then we have to go to
% the beginning (first stage).
stageNumber = length(state.p);
if stage < stageNumber
    nextStage = stage + 1;
else
    nextStage = 1;
end

T0 = 15 + 273.15; % reference temperature for exergy calculation

state.p(nextStage)=state.p(stage);
state.x(nextStage)=NaN;
state.h(nextStage)=XSteam('h_pt',state.p(stage),state.T(nextStage));
state.s(nextStage)=XSteam('s_pt',state.p(stage),state.T(nextStage));

Qh = state.h(nextStage) - state.h(stage); % heat provided at the hot source.
Eloss = T0*(state.s(nextStage) - state.s(stage)); % Exergy loss due to heat transfer.
end

