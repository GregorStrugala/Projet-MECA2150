function e = exergy(state)

%reference state :
T0=15; % celsius
p0=1; % bar

h0=XSteam('h_pt',p0,T0);
s0=XSteam('s_pt',p0,T0);

e=(state.h-h0)-T0*(state.s-s0); % kJ/kg
end