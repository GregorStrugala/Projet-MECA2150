function [Wt,Eloss] = turbine(step,efficiency)
%TO BE REWRITE CASE OF X IS NOT DEFINE !!!

%EXPANSION Update the state after an expansion of specified isentropic efficiency.
%   This MATLAB function has to be used together with a global variable
%   called state. Given a certain step of variables [p,T,h,s,x], the
%   function computes the values of the next step if the transformation is
%   an expansion through a turbine whose isentropic efficiency has to be
%   given as argument. If no efficiency is specified, it is set to 1,
%   making the expansion isentropic.
%       input args:
%           step is an integer corresponding to the index of the state
%           just before the expansion. The function will thus update the
%           state related to the index step+1, unless step is last
%           index of the cycle.
%
%           efficiency is the isentropic efficiency of the turbine.
%
%       output args:
%           Wt is the work done by the turbine on the fluid, in [kJ/kg].
%
%           Eloss is the exergy loss in the turbine, in [kJ/kg].
%
%   [Wt,Eloss] = EXPANSION(step,efficiency)

global state

switch nargin % Check for correct inputs, set efficiency to 1 if none is specified.
    case 0
        msgID = 'EXPANSION:NoStep';
        msg = 'Initial step must be specified.';
        baseException = MException(msgID,msg);
        throw(baseException)
    case 1
        efficiency = 1;
end

% Check if the step is the last one of the cycle, then we have to go to
% the beginning (first step).
stepNumber = length(state.p);
if step < stepNumber
    nextStep = step + 1;
else
    nextStep = 1;
end

% known variables
T1 = state.T(step);
p1 = state.p(step);
p2 = XSteam('psat_T',33);
state.p(nextStep) = p2;

T0 = 15 + 273.15; % reference temperature for exergy calculation

% Find s3 and h3 with tables
s1 = XSteam('s_pT',p1,T1);
h1 = XSteam('h_pT',p1,T1);

% Determine h2 using isentropic efficiency
s2S = s1;
s2v = XSteam('sV_p',p2); % saturated vapour entropy (in the tables)
s2l = XSteam('sL_p',p2); % saturated liquid entropy
x2S = (s2S - s2l)/(s2v - s2l);
h2v = XSteam('hV_p',p2); % saturated vapour enthalpy (in the tables)
h2l = XSteam('hL_p',p2); % saturated liquid enthalpy
h2S = x2S*h2v + (1-x2S)*h2l;
Wis = h1 - h2S; % isentropical work
Wt = efficiency*Wis; % Work done by the expansion
h2 = h1 - Wt; % the work is the enthalpy variation
state.h(nextStep) = h2;

% We find the quality based on h2
x2 = (h2-h2l)/(h2v - h2l);
state.x(nextStep) = x2;
s2 = x2*s2v + (1-x2)*s2l;
state.s(nextStep) = s2;


Eloss = T0*(s2-s1); % Exergy loss due to irreversibilities in the turbine.
end