function h = enthalpy(A,T)
%ENTHALPY computes enthalpy based on janaf data.
%   h = ENTHALPY(A,T) returns the enthalpy of species A (A must be a
%   string) at temperature T. (T can be a vector, in which case h is also a
%   vector) When the temperature is below the limit of janaf (300K), a
%   linear extrapolation is used to compute the enthalpy, so this function
%   is not well suited for temperatures too far below 300K.

h = zeros(size(T));
region1 = find(T<300);    region2 = find(T>=300);
dT = 300-T(region1);
if ~isempty(region1)
    h(region1) = 2*janaf('h',A,300) - janaf('h',A,300+dT);
end
if ~isempty(region2)
    h(region2) = janaf('h',A,T(region2));
end

end