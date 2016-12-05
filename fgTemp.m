function [Tf,h0] = fgTemp(hf,n)
%FGTEMP computes the temperature of flue gases.
%   Tf = FGTEMP(hf,n) returns the temperature of the flue gases after
%   a combustion corresponding to an enthalpy hf and a flue gas composition
%   of CO2, H2O, O2, N2 whose coefficient are contained in this order in
%   vector n.
%
%   [Tf,h0] = FGTEMP(hf,n) also returns the reference enthaly of the
%   flue gas (the enthalpy at 273.15K).

MCO2 = 44.008;
MH2O = 18.01494;
MO2 = 31.998;
MN2 = 28.014;
M = [MCO2 MH2O MO2 MN2];
T0 = 273.15;
baseH = [enthalpy('CO2',T0) enthalpy('H2O',T0) enthalpy('O2',T0) enthalpy('N2',T0)];
h0 = sum(baseH.*M.*n)/sum(n.*M); % kJ/kg of flue gas

%% Use bracketing method to find Tf
Tinf = 300;
Tsup = 5000;
precision = 1e-4; % three significant figures.
while Tsup-Tinf > precision
    Tf = (Tsup+Tinf)/2;
    baseH = [enthalpy('CO2',Tf) enthalpy('H2O',Tf) enthalpy('O2',Tf) enthalpy('N2',Tf)];
    r = (sum(baseH.*M.*n)/sum(n.*M)- h0) - hf ; % h = hf + h0
r = 1 + precision;
while abs(r) > precision
    Tf = (Tsup+Tinf)/2;
    baseH = [enthalpy('CO2',Tf) enthalpy('H2O',Tf) enthalpy('O2',Tf) enthalpy('N2',Tf)];
    r = sum(baseH.*M.*n)/sum(n.*M) - hf - h0; % h = hf + h0
    if r > 0
        Tsup = Tf;
    elseif r < 0
        Tinf = Tf;
    else
        break
    end
end
end