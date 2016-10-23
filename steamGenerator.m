function [] = steamGenerator(step)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
global state
%X est le factor de perte de charge lors de l'apport de chaleur

state.p(step+1)=state.p(step);
state.x(step+1)=NaN;
state.h(step+1)=XSteam('h_pt',state.p(step),state.T(step+1));
state.s(step+1)=XSteam('s_pt',state.p(step),state.T(step+1))


end

