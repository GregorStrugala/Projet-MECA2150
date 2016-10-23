function [Wp,Eloss] = feedPump(stage,eta_siP)
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

global state
% Suffix S : isentropic pump
% Suffix / : non isentropic pump

% Check if the stage is the last one of the cycle, if so we have to go to
% the beginning (first step).
stageNumber = length(state.p);
if stage == stageNumber
    nextStage = 1;
    nextStage2 = nextStage + 1;
elseif stage == stageNumber-1
    nextStage = stage + 1;
    nextStage2 = 1;
else
    nextStage = stage + 1;
    nextStage2 = nextStage + 1;
end

T0 = 15 + 273.15; % reference temperature for exergy calculation

state.x(nextStage)=NaN;

%% Isentropic compression %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s_S=state.s(stage);
T_s=XSteam('T_ps',state.p(nextStage2),s_S);
%v=XSteam('v_ps',state.p(stage),state.s(stage));
h_s=XSteam('h_ps',state.p(nextStage2),s_S);

%% Non isentropic compression %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-> eta_siP = (h2s-h1)/(h2-h1)
 state.h(nextStage)=((h_s-state.h(stage)))/eta_siP+state.h(stage);
 state.p(nextStage)=state.p(nextStage2);%p 110-113 Meca1855
 state.T(nextStage)=XSteam('T_ph',state.p(nextStage),state.h(nextStage));
 state.s(nextStage)=XSteam('s_ph',state.p(nextStage),state.h(nextStage));
 Wp = state.h(stage) - state.h(nextStage); % work done by the pump
 Eloss = T0*(state.s(nextStage) - state.s(stage)); % Exergy loss due to irreversibilities in the pump.
end

