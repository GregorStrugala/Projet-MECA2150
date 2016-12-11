function Cp = cp(A,T)
%CP computes the heat capacity of species A for a certain temperature.
%   CP(A,T) returns the value of the heat capacity of species A (A must be
%   a string) at temperature T, eg cp('CO2',600). T can be a vector.

Cp = zeros(size(T));
region1 = find(T<300);    region2 = find(T>=300);
dT = 300-T(region1);
if ~isempty(region1)
    Cp(region1) = 2*janaf('c',A,300) - janaf('c',A,300+dT);
end
if ~isempty(region2)
    Cp(region2) = janaf('c',A,T(region2));
end
end