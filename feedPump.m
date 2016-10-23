function [] = feedPump(step,eta_siP)
global state
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% Suffix S : isentropic pump
% Suffix / : non isentropic pump

state.x(step+1)=NaN;

%% Isentropic compression %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s_S=state.s(step);
T_s=XSteam('T_ps',state.p(step+2),s_S);
%v=XSteam('v_ps',state.p(step),state.s(step));
h_s=XSteam('h_ps',state.p(step+2),s_S);

%% Non isentropic compression %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-> eta_siP = (h2s-h1)/(h2-h1)
 state.h(step+1)=((h_s-state.h(step)))/eta_siP+state.h(step);
 state.p(step+1)=state.p(step+2);%p 110-113 Meca1855
 state.T(step+1)=XSteam('T_ph',state.p(step+1),state.h(step+1));
 state.s(step+1)=XSteam('s_ph',state.p(step+1),state.h(step+1))

end

