function s = entropy(A,T)
%ENTROPY computes enthalpy based on janaf data.
%   s = ENTROPY(A,T) returns the entropy of species A (A must be a
%   string) at temperature T. (T can be a vector, in which case s is also a
%   vector) When the temperature is below the limit of janaf (300K), a
%   linear extrapolation is used to compute the entropy, so this function
%   is not well suited for temperatures too far below 300K.

s = zeros(size(T));
region1 = find(T<300);    region2 = find(T>=300);
dT = 300-T(region1);
if ~isempty(region1)
    s(region1) = 2*janaf('s',A,300) - janaf('s',A,300+dT);
end
if ~isempty(region2)
    s(region2) = janaf('s',A,T(region2));
end

end