function state = gasTurbine(Pe,Ta,Tf,r,kcc,etaC,etaT,kmec,fuel)
%GASTURBINE characterises a power cycle that uses a gas turbine.
%   state = GASTURBINE(Pe,Ta,Tf,r,kcc,etaC,etaT) displays state, energy
%   and exergy charts for the given parameters.
%   +-------- Mandatory parameters --------+ +--- Optionnal parameters ---+
%   |                                      | |                            |
%   |   Pe: power produced [W]             | |  etaC: polytropic          |
%   |   Ta: temperature of the input air,  | |        efficiency of the   |
%   |       in Kelvin.                     | |        compressor          |
%   |   Tf: Temperature at the output      | |  etaT: polytropic          |
%   |       of the combustion chamber.     | |        efficiency of the   |
%   |   r: compression pressure ratio.     | |        turbine             |
%   |   kcc: combustion chamber pressure   | +----- Default value = 1 ----+
%   |        ratio.                        | |                            |
%   |                                      | |  kmec: mechanical          |
%   +--------------------------------------+ |        efficiency          |
%                                            +----- Default value = 0 ----+
%                                            |                            |
%                                            | fuel: string containing the|
%                                            | fuel used for the comb-    |
%                                            | ustion (see available ones |
%                                            | in combustion function)    |
%                                            +--- Default value = 'CH4' --+

%% Robustness %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 6
    msgID = 'GASTURBINE:MissingArg';
    msg = 'At least one mandatory input argument is missing; see documentation.';
    baseException = MException(msgID,msg);
    throw(baseException)
else
    switch nargin
        case 6
            etaC = 1;
            etaT = 1;
            kmec = 0;
            fuel = 'CH4';
        case 7
            etaT = 1;
            kmec = 0;
            fuel = 'CH4';
        case 8
            kmec = 0;
            fuel = 'CH4';
        case 9
            fuel = 'CH4';
    end
end

%% State calculation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stateNumber = 4;
state(stateNumber).p = []; %preallocation
state(stateNumber).T = [];
state(stateNumber).h = [];
state(stateNumber).s = [];
state(stateNumber).e = [];

% provided data
state(1).p = 1; % 1 bar for the inlet air.
state(1).T = Ta;
state(1).h = AirProp('h',Ta) - AirProp('h',273.15);
state(1).s = AirProp('s',Ta) - AirProp('s',273.15);
state(1).e = AirProp('e',Ta,1);

% Compression
state(2) = compressor(state(1),r,etaC);

% Combustion
[state(3),n,lambda,ma1,LHV] = combustionChamber(state(2),fuel,Tf,r,kcc);

% Expansion
state(4) = turbine2(state(3),r,kcc,n,etaT);

% Put states in a table
Array = (reshape(struct2array(state),5,stateNumber))';
fprintf('\n')
disp(array2table(Array,'VariableNames',{'p','T','h','s','e'}))

%% (T,S) Diagram %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R = 8.314472;
MCO2 = 44.008;
MH2O = 18.01494;
MO2 = 31.998;
MN2 = 28.014;
M = [MCO2 MH2O MO2 MN2];
Mair = 0.21*MO2 + 0.79*MN2;
Ra = R/Mair; % gas constant of the air

T1 = state(1).T;    s1 = state(1).s;
T2 = state(2).T;    s2 = state(2).s;
T3 = state(3).T;    s3 = state(3).s;
T4 = state(4).T;    s4 = state(4).s;

T12 = T1:T2;
s12 = AirProp('s',T12) - AirProp('s',273.15) - etaC*(AirProp('h',T12) -...
    AirProp('h',T1)).*log(T12./T1)./(T12 - T1) + Ra*log(1.01325);
s12(1) = s1;
s12(end) = s2;

T23 = T2:T3;
nM = n.*M/sum(n.*M);
Rg = R*sum(n)/(n*M');
s23 = nM*(hsBase('s',T23) - hsBase('s',273.15*ones(size(T23))))' - Rg*log(r*kcc/1.01325);
s23(1) = s2;
s23(end) = s3;

T34 = T4:T3;
s34 = nM*(hsBase('s',T34) - hsBase('s',273.15*ones(size(T34))))' - log(T34./T3).*(...
    nM*(hsBase('h',T3*ones(size(T34))) - hsBase('h',T34))' )./(etaT*(T3 - T34)) - Rg*log(r*kcc/1.01325);

plot(s12,T12,s23,T23,s34,T34)
hold on
plot(s1,T1,'o',s2,T2,'o',s3,T3,'o',s4,T4,'o')
str = {'1','2','3','4'};
text([s1 s2 s3 s4],[T1 T2 T3 T4],str,'HorizontalAlignment','right')
hold off

%% (H,S) Diagram %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% h12 = AirProp('h',T12) - AirProp('h',273.15);
% h23 = nM*(hsBase('h',T23) - hsBase('h',273.15*ones(size(T23))))';
% h34 = nM*(hsBase('h',T34) - hsBase('h',273.15*ones(size(T34))))';
% plot(s12,h12,s23,h23,s34,h34)

%% Energetic analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% h1 = state(1).h;
% h2 = state(2).h;
% h3 = state(3).h;
% h4 = state(4).h;
% Wmov = h3 - h4;
% Wop = h2 - h1;
% ma = Pe/( (1 - kmec)*Wmov*(h2 + LHV/(lambda*ma1))/h3 - (1 + kmec)*Wop ); % CHECK
% mc = ma/(lambda*ma1);
% mg = ma + mc;
% Pprim = mc*LHV;
% CompLoss = (1-etaC)*ma*Wop;
% TurbLoss = (1/etaT - 1)*mg*Wmov;
% Qexh = mg*h4 - ma*h1; % OK
% MecLoss = kmec*(ma*Wop + mg*Wmov);
% Pmcy = mg*Wmov - ma*Wop;
% pie([Pe MecLoss Qexh Pprim])

    function base = hsBase(prop,T)% if size(T) = 1 x n, then size(base) = n x 4.
        switch prop
            case 'h'
                base = [enthalpy('CO2',T)' enthalpy('H2O',T)' enthalpy('O2',T)' enthalpy('N2',T)'];
            case 's'
                base = [entropy('CO2',T)' entropy('H2O',T)' entropy('O2',T)' entropy('N2',T)'];
        end
    end
end