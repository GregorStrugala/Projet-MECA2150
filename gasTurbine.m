function [stateCelsius,mg,nM,MecLoss,CombLoss,CompLoss,TurbLoss,ma,mc] = gasTurbine(Pe,Ta,Tf,r,kcc,etaC,etaT,kmec,diagrams,fuel)
%GASTURBINE characterises a power cycle that uses a gas turbine.
%   stateCelsius,mg,nM,MecLoss,ComLoss,CompLoss,TurbLoss = GASTURBINE(Pe,Ta,Tf,r,kcc,etaC,etaT) displays state, energy
%   and exergy charts for the given parameters.
%   +-------- Mandatory parameters --------+ +--- Optionnal parameters ---+
%   |                                      | |                            |
%   |   Pe: power produced [kW]            | |  etaC: polytropic          |
%   |   Ta: temperature of the input air,  | |        efficiency of the   |
%   |       in °C.                         | |        compressor          |
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
%                                            |                            |
%                                            |  diagrams: string cell     |
%                                            |  array that says which     |
%   'StateTable','ts','hs','EnPie','ExPie' <-|  diagrams should be        |
%                                            |  displayed                 |
%                                            +-Default value='StateTable'-+

%% Robustness %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 5
    msgID = 'GASTURBINE:MissingArg';
    msg = 'At least one mandatory input argument is missing; see documentation.';
    baseException = MException(msgID,msg);
    throw(baseException)
else
    switch nargin
        case 5
            etaC = 1;
            etaT = 1;
            kmec = 0;
            diagrams = {'StateTable'};
            fuel = 'CH4';
        case 6
            etaT = 1;
            kmec = 0;
            diagrams = {'StateTable'};
            fuel = 'CH4';
        case 7
            kmec = 0;
            diagrams = {'StateTable'};
            fuel = 'CH4';
        case 8
            diagrams = {'StateTable'};
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
Ta = Ta + 273.15; % switch to Kelvin
Tf = Tf + 273.15;
state(1).p = 1; % 1 bar for the inlet air.
state(1).T = Ta;
state(1).h = AirProp('h',Ta) - AirProp('h',273.15);
state(1).s = AirProp('s',Ta) - AirProp('s',273.15);
state(1).e = AirProp('e',Ta,1);

% Compression
state(2) = compressor(state(1),r,etaC);

% Combustion
[state(3),n,lambda,ma1,LHV,ec] = combustionChamber(state(2),fuel,Tf,r,kcc);

% Expansion
state(4) = turbine2(state(3),r,kcc,n,etaT);

stateCelsius = state;
for i=1:4
    stateCelsius(i).T = state(i).T - 273.15;
end

R = 8.314472;
MCO2 = 44.008;
MH2O = 18.01494;
MO2 = 31.998;
MN2 = 28.014;
M = [MCO2 MH2O MO2 MN2];
nM = n.*M/sum(n.*M);

%% Table & Diagrams %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(diagrams,'all')
    all = 1;
else
    all = 0;
end
% State table
if  any(ismember('StateTable',diagrams))||all
    % Put states in a table
    Array = (reshape(struct2array(stateCelsius),5,stateNumber))';
    fprintf('\n')
    disp(array2table(Array,'VariableNames',{'p','T','h','s','e'}))
end

if any(ismember({'ts','hs'},diagrams))||all
    Mair = 0.21*MO2 + 0.79*MN2;
    Ra = R/Mair; % gas constant of the air
    
    T1 = state(1).T;    s1 = state(1).s;    Tc1 = stateCelsius(1).T;  
    T2 = state(2).T;    s2 = state(2).s;    Tc2 = stateCelsius(2).T;
    T3 = state(3).T;    s3 = state(3).s;    Tc3 = stateCelsius(3).T;
    T4 = state(4).T;    s4 = state(4).s;    Tc4 = stateCelsius(4).T;
    
    T12 = T1:T2;
    s12 = AirProp('s',T12) - AirProp('s',273.15) - etaC*(AirProp('h',T12) -...
        AirProp('h',T1)).*log(T12./T1)./(T12 - T1) + Ra*log(1.01325);
    s12(1) = s1;
    s12(end) = s2;
    
    T23 = T2:T3;
    Rg = R*sum(n)/(n*M');
    s23 = nM*(hsBase('s',T23) - hsBase('s',273.15*ones(size(T23))))' - Rg*log(r*kcc/1.01325);
    s23(1) = s2;
    s23(end) = s3;
    
    
    T34 = T4:T3;
    s34 = nM*(hsBase('s',T34) - hsBase('s',273.15*ones(size(T34))))' - log(T34./T3).*(...
        nM*(hsBase('h',T3*ones(size(T34))) - hsBase('h',T34))' )./(etaT*(T3 - T34)) - Rg*log(r*kcc/1.01325);
end

% (T,s) Diagram
if any(ismember('ts',diagrams))||all
    T12 = T12 - 273.15; % display temperature in °C
    T23 = T23 - 273.15;
    T34 = T34 - 273.15;
    figure
    plot(s12,T12,s23,T23,s34,T34)
    hold on
    plot(s1,Tc1,'o',s2,Tc2,'o',s3,Tc3,'o',s4,Tc4,'o')
    str = {'1','2','3','4'};
    text([s1 s2 s3 s4],[Tc1 Tc2 Tc3 Tc4],str,'HorizontalAlignment','right')
    hold off
end

h1 = state(1).h; % outside of if clause because used also for energetic analysis
h2 = state(2).h;
h3 = state(3).h;
h4 = state(4).h;
% (h,s) Diagram
if any(ismember('hs',diagrams))||all
    figure
    h12 = AirProp('h',T12) - AirProp('h',273.15);
    h23 = nM*(hsBase('h',T23) - hsBase('h',273.15*ones(size(T23))))';
    h34 = nM*(hsBase('h',T34) - hsBase('h',273.15*ones(size(T34))))';
    h12(end) = h2;
    h23(1) = h2;
    plot(s12,h12,s23,h23,s34,h34)
    hold on
    plot(s1,h1,'o',s2,h2,'o',s3,h3,'o',s4,h4,'o')
    str = {'1','2','3','4'};
    text([s1 s2 s3 s4],[h1 h2 h3 h4],str,'HorizontalAlignment','right')
    hold off
end

%% Energetic Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Wmov = h3 - h4;
Wop = h2 - h1;
ma = Pe/( (1 - kmec)*Wmov*(h2 + LHV/(lambda*ma1))/h3 - (1 + kmec)*Wop ); % CHECK
mc = ma/(lambda*ma1);
mg = ma + mc;
Pprim = mc*LHV;
Qexh = mg*h4 - ma*h1;
MecLoss = kmec*(ma*Wop + mg*Wmov);
% Energy pie chart
if any(ismember('EnPie',diagrams))||all
    figure
    labels = {['Pe' char(10) num2str(abs(Pe/1000)) ' MW' char(10)]; ...
        ['Meca' char(10) num2str(abs(MecLoss/1000)) ' MW' char(10)]; ...
        ['Exhaust' char(10) num2str(abs(Qexh/1000)) ' MW' char(10)]};
    pie(abs([Pe MecLoss Qexh]),labels)
    title(['Primary energy flux: ' num2str(abs(Pprim/1000)) ' MW'])
end

%% Exergetic Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
e1 = state(1).e;
e2 = state(2).e;
e3 = state(3).e;
e4 = state(4).e;
CompLoss = ma*((h2 - h1) - (e2 - e1));
TurbLoss = mg*((e3 - e4) - (h3 - h4));
CombLoss = mc*ec - (mg*e3 - ma*e2);
Eexh = mg*e4 - ma*e1;
% Exergy pie chart
if any(ismember('ExPie',diagrams))||all
    figure
    labels = {['Pe' char(10) num2str(abs(Pe/1000)) ' MW' char(10)]; ...
        ['Meca' char(10) num2str(abs(MecLoss/1000)) ' MW' char(10)]; ...
        ['C & T irrev.' char(10) num2str(abs((CompLoss+TurbLoss))/1000) ' MW' char(10)]; ...
        ['Exhaust' char(10) num2str(abs(Eexh/1000)) ' MW' char(10)]; ...
        ['Combustion' char(10) num2str(abs(CombLoss/1000)) ' MW' char(10)]};
    pie(abs([Pe MecLoss CompLoss+TurbLoss Eexh CombLoss]),labels)
    title(['Primary exergy flux: ' num2str(abs(mc*ec/1000)) ' MW'])
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