function [etaCombex,etaGen,fuelFlowRate,eExh,ec,ef,LHV] = combustion(fuel,lambda,Texh,Ta,wallLoss,Psg)
%COMBUSTION compute parameters associated with a certain combustion.
%   etaCombex = COMBUSTION(fuel,lambda) returns the efficiency of a
%   combustion of a fuel whose chemical formula must be indicated in a
%   string contained in variable fuel, and be one of the following:
%       +-----------+
%       |   C       |
%       |   CH1.8   |
%       |   CH4     |
%       |   C3H8    |
%       |   H2      |
%       |   CO      |
%       +-----------+
%   lambda is the air excess coefficient. If no lambda is specified, its
%   default value is set to 1. Additionnaly, if no fuel is specified, the
%   default fuel used is CH4, i.e. COMBUSTION() returns the efficiency of a
%   stoichiometric combustion of CH4.
%
%   etaCombex = COMBUSTION(fuel,lambda,Texh,Ta) allows to tune
%   the temperature (in Kelvins) of the exhaust gases and of the ambient
%   air. The defualt values if they are not specified are Texh = 393.15 and
%   Ta = 288.15. Psg is the power supplied by the steam generator (vapor
%   flow rate times enthalpy variation).
%
%   [etaCombex,etaGen] = COMBUSTION(fuel,lambda,Texh,Ta,wallLoss) also
%   returns the energetic efficieny. wallLoss is the energy lost
%   because of a non-perfect insulation in the stack, it is expressed as a
%   fraction of the LHV, and its default value is 1% = 0.01.
%
%   [~,~,fuelFlowRate] = COMBUSTION(fuel,lambda,Texh,Ta,wallLoss,Psg)
%   returns the fuel flow rate corresponding to a certain power supplied by
%   the steam generator (vapor flow rate times enthalpy variation). It is
%   given in the argument Psg and MUST be provided (no default values).
%
%   [~,~,~,eExh,ec,ef,LHV] = COMBUSTION(fuel,...) also returns the exergy
%   of the exhaust gases, the exergy of the fuel, the exergy of the flue
%   gas and the LHV of the fuel.

%% Robustness %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargout>2 && nargin<6
    msgID = 'COMBUSTION:NotEnoughArguments';
    msg = 'The power of the steam generator must be provided!';
    baseException = MException(msgID,msg);
    throw(baseException)
end
switch nargin
    case 0
        fuel = 'CH4';
        lambda = 1;
        Texh = 273.15 + 120;
        Ta = 273.15 + 15;
        wallLoss = 0.01;
    case 1
        lambda = 1;
        Texh = 273.15 + 120;
        Ta = 273.15 + 15;
        wallLoss = 0.01;
    case 2
        Texh = 273.15 + 120;
        Ta = 273.15 + 15;
        wallLoss = 0.01;
    case 3
        Ta = 273.15 + 15;
        wallLoss = 0.01;
    case 4
        wallLoss = 0.01;
end

%%
T0 = 273.15 + 15; % [K]
nC = 12; % modified only for H2, where no carbon is present
switch fuel
    case 'C' % C + L(O2 + 3.76N2) -> CO2 + (L-1)O2 + 3.76L N2
        nCO2 = 1;
        nH2O = 0;
        nO2 = lambda-1;
        nN2 = 3.76*lambda;
        x = 0; % air demand value computation
        y = 0;
        LHV = 32780; % kJ/kg (of fuel)
        ec = 34160; % kJ/kg (of fuel)
    case 'CH1.8' % CH1.8 + 1.45L(O2 + 3.76N2) -> CO2 + 0.9H2O + 1.45(L-1)O2 + 5.452L N2
        nCO2 = 1;
        nH2O = 0.9;
        nO2 = 1.45*(lambda-1);
        nN2 = 5.452*lambda;
        x = 0;
        y = 1.8;
        LHV = 42900;
        ec = 45710;
    case 'CH4' % CH4 + 2L(O2 + 3.76N2) -> CO2 + 2H2O + 2(L-1)O2 + 7.52L N2
        nCO2 = 1;
        nH2O = 2;
        nO2 = 2*(lambda-1);
        nN2 = 7.52*lambda;
        x = 0;
        y = 4;
        LHV = 50150;
        ec = 52215;
    case 'C3H8' % C3H8 + 5L(O2 + 3.76N2) -> 3CO2 + 4H2O + 5(L-1)O2 + 18.8L N2
        nCO2 = 3;
        nH2O = 4;
        nO2 = 5*(lambda-1);
        nN2 = 18.8*lambda;
        x = 0;
        y = 8/3;
        LHV = 46465;
        ec = 49045;
    case 'H2' % H2 + 0.5L(O2 + 3.76N2) -> H2O + 0.5(L-1)O2 + 1.88L N2
        nCO2 = 0;
        nH2O = 1;
        nO2 = 0.5*(lambda-1);
        nN2 = 1.88*lambda;
        nC = 0; % no carbon
        x = 0;
        y = 2;
        LHV = 120900;
        ec = 118790;
    case 'CO' % CO + 0.5L(O2 + 3.76N2) -> CO2 + 0.5(L-1)O2 + 1.88L N2
        nCO2 = 1;
        nH2O = 0;
        nO2 = 0.5*(lambda-1);
        nN2 = 1.88*lambda;
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
n = [nCO2 nH2O nO2 nN2];
MCO2 = 44.008;
MH2O = 18.01494;
MO2 = 31.998;
MN2 = 28.014;
M = [MCO2 MH2O MO2 MN2];
nM = n.*M;
Mair = 0.21*MO2 + 0.79*MN2;
ha = (0.21*MO2*enthalpy('O2',Ta) + 0.79*MN2*enthalpy('N2',Ta))/Mair; % kJ/kg (of air)
hf = (LHV + lambda*ma*ha)/(1 + lambda*ma);
% temperature of the flue gases:
[Tf,h0] = fgTemp(hf,n); % h0 is the reference enthaply at 0°C

% quantites needed to compute the flue gas exergy
baseHf0 = hsBase('h',T0);
hf0 = baseHf0*(nM)'/sum(nM) - h0; % integration of cpf between 0 and T0.
baseSf = hsBase('s',Tf);
sf = baseSf*(nM)'/sum(nM);
baseSf0 = hsBase('s',T0);
sf0 = baseSf0*(nM)'/sum(nM);

ef = (hf - hf0) - T0*(sf - sf0);
etaCombex = ef*(1+lambda*ma)/ec; % exergetic efficiency

if nargout>1
    hExh = hsBase('h',Texh)*(nM)'/sum(nM);
    ha0 = (0.21*MO2*enthalpy('O2',273.15) + 0.79*MN2*enthalpy('N2',273.15))/Mair; % kJ/kg (of air)
    stackLoss = ( (1 + lambda*ma)*(hExh - h0) - lambda*ma*(ha - ha0) )/LHV;
    etaGen = 1 - stackLoss - wallLoss;
    if etaGen < 0
        msgID = 'COMBUSTION:InvalidEnergyLosses';
        msg = ['Physical inconsistence warning: the energy losses at the stack '...
            'and the walls represents more than the totality of the supplied energy!'];
        baseException = MException(msgID,msg);
        throw(baseException)
    end
end
if nargout>2
   fuelFlowRate = abs(Psg/(etaGen*LHV));
end
if nargout>3
    sExh = hsBase('s',Texh)*(nM)'/sum(nM);
    stateExh.h = hExh;
    stateExh.s = sExh;
    fprintf('\n h = %f\n s = %f\n',hExh,sExh)
    eExh = exergy(stateExh);
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