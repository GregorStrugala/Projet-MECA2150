function steamPowerPlant(deltaT, Triver, Tmax, steamPressure)
%STEAMPOWERPLANT characterises a steam power plant using Rankine cycle.
%   STEAMPOWERPLANT(deltaT, Triver, Tmax, steamPressure) displays a table
%   with the values of the variables p, T, x, h, s at the differents states
%   of the cycle, along with the work of the cycle Wmcy.
%   deltaT is the difference of temperature between the cold source and the
%   condensation temperature of the fluid in the cycle, Triver is the
%   temperature of the cold source, Tmax is the temperature of the
%   superheated vapour before it expands, and steamPressure is the pressure
%   at the same state.

stateNumber = 4;
state(stateNumber).p = 0; % preallocation
state(stateNumber).T = 0;
state(stateNumber).x = 0;
state(stateNumber).h = 0;
state(stateNumber).s = 0;
for i=1:stateNumber-1
    state(i).p = 0;
    state(i).T = 0;
    state(i).x = 0;
    state(i).h = 0;
    state(i).s = 0;
end

Tcond=Triver+deltaT;

% Given parameters
state(1).T = Tcond;
state(4).T = state(1).T;
state(3).p = steamPressure;
state(3).T = Tmax;

% We begin the cycle at the state (3)
[state(4),state(3),Wmov,ExLossT,eta_turbex] = turbine(state(3),Tcond,0.88);
state(1) = condenser(state(4));
[state(2),Wop,ExlossP] = feedPump(state(1),steamPressure,0.8);
% [Qh,Exloss] = steamGenerator(state(2),Tmax)


Wmcy = Wmov+Wop; % note: Wmov<0, Wop>0

%eta_cyclen=Wmcy/Qh;
%eta_gen=mv*(state(3).h-state(2).h)/(mc*LHV);
% definir une fonction combustion pour def LHV et mc mettre en argument Pe pour le debit de vapeur.
%mv se trouve avec le rendement mec (eta_mec)
%eta_mec=Pe/(mc*Wmcy);
M = (reshape(struct2array(state),5,stateNumber))';
fprintf('\n')
disp(array2table(M,'VariableNames',{'p','T','x','h','s'}))

fprintf('Wmcy = %f kJ/kg\n\n',Wmcy)
end