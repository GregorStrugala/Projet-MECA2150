function [stateO,n,lambda] = combustionChamber(stateI,fuel,Tf,kcc)
%COMBUSTIONCHAMBER computes parameters corresponding to the combustion in a
%power cycle using a gas turbine.
%   [stateO,n,lambda] = combustionChamber(stateI,fuel,Tf,kcc) returns the
%   state after the combustion, the composition of the flue gas and the
%   excess air coefficient. StateI is the input state, fuel is a string
%   containing the chemical formula of the fuel used for the combustion, Tf
%   is the output temperature, and kcc is the pressure ratio pOut/pIn <1.

pI = stateI.p;
Ti = stateI.T;
pO = kcc*pI;
To = Tf;

T0 = 273.15 + 15; % [K]
nC = 12; % modified only for H2, where no carbon is present
lambda = 1.7; % first guess, then we have to iterate
switch fuel % the parameters depending on lambda are assigned in a function that can be used in a recursive loop.
    case 'C' % C + L(O2 + 3.76N2) -> CO2 + (L-1)O2 + 3.76L N2
        nCO2 = 1;
        nH2O = 0;
        x = 0; % air demand value computation
        y = 0;
        LHV = 32780; % kJ/kg (of fuel)
        ec = 34160; % kJ/kg (of fuel)
    case 'CH1.8' % CH1.8 + 1.45L(O2 + 3.76N2) -> CO2 + 0.9H2O + 1.45(L-1)O2 + 5.452L N2
        nCO2 = 1;
        nH2O = 0.9;
        x = 0;
        y = 1.8;
        LHV = 42900;
        ec = 45710;
    case 'CH4' % CH4 + 2L(O2 + 3.76N2) -> CO2 + 2H2O + 2(L-1)O2 + 7.52L N2
        nCO2 = 1;
        nH2O = 2;
        x = 0;
        y = 4;
        LHV = 50150;
        ec = 52215;
    case 'C3H8' % C3H8 + 5L(O2 + 3.76N2) -> 3CO2 + 4H2O + 5(L-1)O2 + 18.8L N2
        nCO2 = 3;
        nH2O = 4;
        x = 0;
        y = 8/3;
        LHV = 46465;
        ec = 49045;
    case 'H2' % H2 + 0.5L(O2 + 3.76N2) -> H2O + 0.5(L-1)O2 + 1.88L N2
        nCO2 = 0;
        nH2O = 1;
        nC = 0; % no carbon
        x = 0;
        y = 2;
        LHV = 120900;
        ec = 118790;
    case 'CO' % CO + 0.5L(O2 + 3.76N2) -> CO2 + 0.5(L-1)O2 + 1.88L N2
        nCO2 = 1;
        nH2O = 0;
        x = 1;
        y = 0;
        LHV = 10085;
        ec = 9845;
    otherwise
        msgID = 'COMBUSTION:Invalidfuel';
        msg = 'The chemical formula of the fuel burnt must be one of those indicated in the documentation.';
        baseException = MException(msgID,msg);
        throw(baseException)
end
ma = ( (32 + 3.76*28)*(1 + (y-2*x)/4) )/(nC + y + 16*x); % [kg_air/kg_fuel]
MCO2 = 44.008;
MH2O = 18.01494;
MO2 = 31.998;
MN2 = 28.014;
M = [MCO2 MH2O MO2 MN2];
Mair = 0.21*MO2 + 0.79*MN2;
ha = (0.21*MO2*enthalpy('O2',Ti) + 0.79*MN2*enthalpy('N2',Ti))/Mair; % kJ/kg (of air)
precision = 1e-4;
lambdaOld = lambda + precision + 1; % be sure to enter the while loop
while abs(lambda - lambdaOld) > precision
    [nO2,nN2] = productsCoeff(fuel,lambda);
    n = [nCO2 nH2O nO2 nN2];
    nM = n.*M;
    hO = hsBase('h',Tf)*(nM)'/sum(nM);
    hf = hO - (hsBase('h',273.15)*(nM)'/sum(nM));
    lambdaOld = lambda;
    lambda = (LHV - hf)/(ma*(hf - ha));
end

[nO2,nN2] = productsCoeff(fuel,lambda);
n = [nCO2 nH2O nO2 nN2];
nM = n.*M;
hO = (hsBase('h',Tf) - hsBase('h',273.15))*(nM)'/sum(nM);
h0 = hsBase('h',T0)*(nM)'/sum(nM);
sO = (hsBase('s',Tf) - hsBase('s',273.15))*(nM)'/sum(nM);
s0 = hsBase('s',T0)*(nM)'/sum(nM);
eO = (hO - h0) - T0*(sO - s0);

stateO.p = pO;
stateO.T = To;
stateO.h = hO;
stateO.s = sO;
stateO.e = eO;

    function [nO2,nN2] = productsCoeff(fuel,lambda)
        switch fuel
            case 'C' % C + L(O2 + 3.76N2) -> CO2 + (L-1)O2 + 3.76L N2
                nO2 = lambda-1;
                nN2 = 3.76*lambda;
            case 'CH1.8' % CH1.8 + 1.45L(O2 + 3.76N2) -> CO2 + 0.9H2O + 1.45(L-1)O2 + 5.452L N2
                nO2 = 1.45*(lambda-1);
                nN2 = 5.452*lambda;
            case 'CH4' % CH4 + 2L(O2 + 3.76N2) -> CO2 + 2H2O + 2(L-1)O2 + 7.52L N2
                nO2 = 2*(lambda-1);
                nN2 = 7.52*lambda;
            case 'C3H8' % C3H8 + 5L(O2 + 3.76N2) -> 3CO2 + 4H2O + 5(L-1)O2 + 18.8L N2
                nO2 = 5*(lambda-1);
                nN2 = 18.8*lambda;
            case 'H2' % H2 + 0.5L(O2 + 3.76N2) -> H2O + 0.5(L-1)O2 + 1.88L N2
                nO2 = 0.5*(lambda-1);
                nN2 = 1.88*lambda;
            case 'CO' % CO + 0.5L(O2 + 3.76N2) -> CO2 + 0.5(L-1)O2 + 1.88L N2
                nO2 = 0.5*(lambda-1);
                nN2 = 1.88*lambda;
        end
    end
    function base = hsBase(prop,T)% if size(T) = 1 x n, then size(base) = n x 4. 
        switch prop
            case 'h'
                base = [enthalpy('CO2',T)' enthalpy('H2O',T)' enthalpy('O2',T)' enthalpy('N2',T)'];
            case 's'
                base = [entropy('CO2',T)' entropy('H2O',T)' entropy('O2',T)' entropy('N2',T)'];
        end
    end

end