function Cp = cp(T,A)
%CP computes the heat capacity of species A for a certain temperature.
%   CP(T,A) returns the value of the heat capacity of species A (A must be
%   a string) at temperature T, eg cp(600,'CO2').

if T < 300
    dT = 300-T;
    Cp = 2*janaf('c',A,300) - janaf('c',A,300+dT);
else
    Cp = janaf('c',A,T);
end
end

