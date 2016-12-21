function stateO = turbine2(stateI,r,kcc,n,etaT)
%TURBINE2 gives the output state of a turbine with pressure ratio r*kcc.
%   stateO = TURBINE2(stateI,r,kcc,n,etaT) returns the state variables
%   contained in the structure stateO after the expansion. r is the
%   pressure ratio of the compressor, and kcc that in the combustion
%   chamber. n is a vector containing the composition of the flue gas
%   exiting the combustion chamber (CO2,H2O,O2,N2) in that precise order.
%   etaT is the polytropic efficency, its default value is 1.

%% Robustness %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch nargin
    case 0
        msgID = 'TURBINE2:NoState';
        msg = 'Initial state must be specified.';
        baseException = MException(msgID,msg);
        throw(baseException)
    case 1
        msgID = 'TURBINE2:NoRatio';
        msg = 'Input state and pressure ratios must be specified.';
        baseException = MException(msgID,msg);
        throw(baseException)
    case 2
        msgID = 'TURBINE2:NoRatio';
        msg = 'Input state and pressure ratios must be specified.';
        baseException = MException(msgID,msg);
        throw(baseException)
    case 3
        msgID = 'TURBINE2:NoComposition';
        msg = 'The composition of the gases must be specified';
        baseException = MException(msgID,msg);
        throw(baseException)
    case 4
        etaT = 1;
end
%% State caluclation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pI = stateI.p;
Ti = stateI.T;
rKcc = r*kcc;
pO = pI/rKcc;
hI = stateI.h;

% Use a bracketing method to find To
R = 8.314472;
MCO2 = 44.008;
MH2O = 18.01494;
MO2 = 31.998;
MN2 = 28.014;
M = [MCO2 MH2O MO2 MN2];
n = n(:); % make sure that n is a column vector to perform scalar product
Mfg = M*n/sum(n);
nM = n'.*M;
nM = nM./sum(nM); % make the normalization before the loop to avoid too many computations.
Rg = R/Mfg; % gas constant of the flue gas
hfI = hI + hsBase('h',273.15)*(nM)';
Tinf = 273;
Tsup = Ti;
To = (Tinf + Tsup)/2;
precision = 1e-7; % three significant figures.
while Tsup-Tinf > precision
    a = log(To/Ti)/log(rKcc) + Rg*etaT*(Ti - To)/( hfI - hsBase('h',To)*(nM)' );
    if a < 0
        Tinf = To;
    elseif a > 0;
        Tsup = To;
    else
        break
    end
    To = (Tinf + Tsup)/2;
end

hO = (hsBase('h',To) - hsBase('h',273.15))*(nM)';
sO = (hsBase('s',To) - hsBase('s',273.15))*(nM)';
T0 = 273.15 + 15;

h0 = hsBase('h',T0)*(nM)'/sum(nM);
s0 = hsBase('s',T0)*(nM)'/sum(nM);
eO = (hO - h0 + hsBase('h',273.15)*(nM)'/sum(nM)) - T0*(sO - s0 + hsBase('s',273.15)*(nM)'/sum(nM));

stateO.p = pO;
stateO.T = To;
stateO.h = hO;
stateO.s = sO;
stateO.e = eO;

    function base = hsBase(prop,T)% if size(T) = 1 x n, then size(base) = n x 4.
        switch prop
            case 'h'
                base = [enthalpy('CO2',T)' enthalpy('H2O',T)' enthalpy('O2',T)' enthalpy('N2',T)'];
            case 's'
                base = [entropy('CO2',T)' entropy('H2O',T)' entropy('O2',T)' entropy('N2',T)'];
        end
    end
end

