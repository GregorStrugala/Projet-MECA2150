function stateO = compressor(stateI,r,etaC)
%COMPRESSOR gives the output state of a compressor with pressure ratio r.
%   stateO = COMPRESSOR(stateI,r,etaC) returns the state variables
%   contained in the structure stateO after the compression. Only p and T
%   must be non-empty fields in the state input. r is the pressure ratio
%   between the output and the input, and etaC is the polytropic efficency.
%   The default value of the polytropic efficiency is 1.

%% Robustness %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch nargin
    case 0
        msgID = 'COMPRESSOR:NoState';
        msg = 'Initial state must be specified.';
        baseException = MException(msgID,msg);
        throw(baseException)
    case 1
        msgID = 'COMPRESSOR:NoRatio';
        msg = 'Input state and pressure ratio must be specified.';
        baseException = MException(msgID,msg);
        throw(baseException)
    case 2
        etaC = 1;
end

%% State caluclation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pI = stateI.p;
Ti = stateI.T;
pO = r*pI;
haI = AirProp('h',Ti);

% Use a bracketing method to find To
R = 8.314472;
MO2 = 31.998;
MN2 = 28.014;
Mair = 0.21*MO2 + 0.79*MN2;
Ra = R/Mair; % gas constant of the air
Tinf = Ti;
Tsup = 3000;
To = (Tinf + Tsup)/2;
precision = 1e-4; % three significant figures.
a = 1 + precision;
while abs(a) > precision
    a = log(To/Ti)/log(r) - Ra*(To-Ti)/(etaC*( AirProp('h',To) - haI ));
    if a > 0
        Tsup = To;
    elseif a < 0;
        Tinf = To;
    else
        break
    end
    To = (Tinf+Tsup)/2;
end

hO = AirProp('h',To) - AirProp('h',273.15);
sO = AirProp('s',To) - AirProp('s',273.15);
eO = AirProp('e',To);

stateO.p = pO;
stateO.T = To;
stateO.h = hO;
stateO.s = sO;
stateO.e = eO;
end