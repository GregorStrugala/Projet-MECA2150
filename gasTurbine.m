function state = gasTurbine(Pe,pa,Ta,Tf,r,kcc,etaC,etaT,fuel)
%GASTURBINE characterises a power cycle that uses a gas turbine.
%   GASTURBINE(Pe,pa,Ta,Tf,r,kcc,etaC,etaT) displays state, energy
%   and exergy charts for the given parameters.
%   +-------- Mandatory parameters --------+ +--- Optionnal parameters ---+
%   |                                      | |                            |
%   |   Pe: power produced [W]             | |  etaC: polytropic          |
%   |   pa,Ta: pression and temperature [K]| |        efficiency of the   |
%   |          of the input air.           | |        compressor          |
%   |   Tf: Temperature at the output      | |  etaT: polytropic          |
%   |       of the combustion chamber.     | |        efficiency of the   |
%   |   r: compression pressure ratio.     | |        turbine             |
%   |   kcc: combustion chamber pressure   | +---- Default value = 1 -----+
%   |        ratio.                        | |                            |
%   |                                      | | fuel: string containing the|
%   +--------------------------------------+ | fuel used for the comb-    |
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
            fuel = 'CH4';
        case 7
            etaT = 1;
            fuel = 'CH4';
        case 8
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
state(1).p = pa;
state(1).T = Ta;
state(1).h = AirProp('h',Ta) - AirProp('h',273.15);
state(1).s = AirProp('s',Ta) - AirProp('s',273.15);
state(1).e = 0;

% Compression
state(2) = compressor(state(1),r,etaC);

% Combustion
[state(3),n,~] = combustionChamber(state(2),fuel,Tf,kcc);

% Expansion
state(4) = turbine2(state(3),r,kcc,n,etaT);

% Put states in a table
M = (reshape(struct2array(state),5,stateNumber))';
fprintf('\n')
disp(array2table(M,'VariableNames',{'p','T','h','s','e'}))

end

