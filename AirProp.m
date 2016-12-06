function x = AirProp(prop,T)
%AIRPROP computes a property of the air at temperature T.
%   x = AIRPROP(prop,T) returns the value of the enthalpy (prop = 'h') or
%   the entropy (prop = 's') of the air at a given temperature T. T must be
%   expressed in Kelvin, and can be a vector. The units of h are kJ/kg of
%   air, and those of s are kJ/(kg K) of air.

MO2 = 31.998;
MN2 = 28.014;
Mair = 0.21*MO2 + 0.79*MN2;

switch prop
    case 'h'
        x = (0.21*MO2*enthalpy('O2',T) + 0.79*MN2*enthalpy('N2',T))/Mair;
    case 's'
        x = (0.21*MO2*entropy('O2',T) + 0.79*MN2*entropy('N2',T))/Mair;
    case 'e'
        T0 = 273.15 + 15;
        deltaH = AirProp('h',T) - AirProp('h',T0);
        deltaS = AirProp('s',T) - AirProp('s',T0);
        x = deltaH - T0*deltaS;
end
end