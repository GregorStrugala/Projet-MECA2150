function[]=steamPowerPlant(deltaT, Triver, Tmax, steamPressure, Pe, nF, nR, dTpinch)
%TEST
%STEAMPOWERPLANT characterises a steam power plant using Rankine cycle.
%   STEAMPOWERPLANT(deltaT, Triver, Tmax, steamPressure, Pe, n) displays a table
%   with the values of the variables p, T, x, h, s at the differents states
%   of the cycle, along with the work of the cycle Wmcy.
%   deltaT is the difference of temperature between the cold source and the
%   condensation temperature of the fluid in the cycle, Triver is the
%   temperature of the cold source, Tmax is the temperature of the
%   superheated vapour before it expands, steamPressure is the pressure
%   at the same state, Pe is the electric power that the steam power plant
%   produces and n is the number of feed heating.

% ROBUSTESSE : pour la robustesse du code ce serait bien de mettre des
% conditions sur nF, ex: si feedHeat=0 et nF !=0

%% Robustness %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch nargin % Check for correct inputs, set efficiency to 1 if none is specified.
    case 0
        msgID = 'STEAMPOWERPLANT:NoState';
        msg = 'Initial state must be specified.';
        baseException = MException(msgID,msg);
        throw(baseException)
    case 1
        msgID = 'STEAMPOWERPLANT:NodT';
        msg = 'dT must be specified.';
        baseException = MException(msgID,msg);
        throw(baseException)
    case 2
        msgID = 'STEAMPOWERPLANT:NoTriver';
        msg = 'Triver must be specified.';
        baseException = MException(msgID,msg);
        throw(baseException)
    case 3
        msgID = 'STEAMPOWERPLANT:NoTmax';
        msg = 'Tmax must be specified.';
        baseException = MException(msgID,msg);
        throw(baseException)
    case 4
        msgID = 'STEAMPOWERPLANT:NoSteamPressure';
        msg = 'steamPressure must be specified.';
        baseException = MException(msgID,msg);
        throw(baseException)
end

%% State calculations
%efficiencies
eta_mec=0.98;
eta_gen=0.945;
eta_siT=0.88;
eta_siP=0.85;

%turbineEfficiency=0.98;
%pumpEfficiency=0.98;

Tcond=Triver+deltaT;

%%%%%%%%%%%%%%%%%%%%%%% COMBINING, FEEDHEATING ONLY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nF>0
    %stateNumber=4+2+4*n;
    stateNumber=11+2*nR; %independent of nF!
    state(stateNumber,nF).p = []; % preallocation
    state(stateNumber,nF).T = [];
    state(stateNumber,nF).x = [];
    state(stateNumber,nF).h = [];
    state(stateNumber,nF).s = [];
%     for i=1:stateNumber-1
%         for j=1:nF
%             state(i,j).p = 0;
%             state(i,j).T = 0;
%             state(i,j).x = 0;
%             state(i,j).h = 0;
%             state(i,j).s = 0;
%         end
%     end
    
    % Given parameters
    state(8+2*nR).T = Tcond;
    state(8+2*nR).p = XSteam('psat_T',Tcond);
    
    %definition of the state(3) : complete !
    state(3).p = steamPressure;
    state(3).T = Tmax;
    state(3).x = nan;
    state(3).s = XSteam('s_pT',steamPressure,Tmax);
    state(3).h = XSteam('h_pT',steamPressure,Tmax);
    
    % We begin the cycle at the state (3)
    if nR == 0
        [state(8),Wmov,e4,turbineLoss,ExLossT,eta_turbex] = turbine(state(3),state(8).p,eta_siT,eta_mec);
    else
        pOut = XSteam('psat_T',Tcond);
        [state, Wmov]=reHeating(state,state(3),0.18,pOut,eta_siT,eta_mec,eta_gen,nF,nR);
    end
    
    [state(9+2*nR),~,e1,condenserLoss,~] = condenser(state(8+2*nR));
    [state]=feedHeating(state,steamPressure,0.8,0.88,nF,nR,dTpinch); %to do energetic and exergetic analysis
    [state(2),Wop,e2,pumpLoss,ExlossP] = feedPump(state(1),steamPressure,eta_siP,eta_mec);
    [~,Qh,e3,steamGenLoss,Exloss] = steamGenerator(state(2),Tmax,eta_gen);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%% REHEATING ONLY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif  nR > 0 && nF == 0
    stateNumber=4+2*nR;
    state(stateNumber,nR+1).p = 0; % preallocation
    state(stateNumber,nR+1).T = 0;
    state(stateNumber,nR+1).x = 0;
    state(stateNumber,nR+1).h = 0;
    state(stateNumber,nR+1).s = 0;
    for i=1:stateNumber-1
        for j=1:nR
            state(i,j).p = 0;
            state(i,j).T = 0;
            state(i,j).x = 0;
            state(i,j).h = 0;
            state(i,j).s = 0;
        end
    end
    
    % Given parameters
    state(1).T = Tcond;
    state(1).p=XSteam('psat_T',Tcond);
    state(4,2).T = state(1).T;
    
    %definition of the state(3) : complete !
    state(3).p = steamPressure;
    state(3).T = Tmax;
    state(3).x = nan;
    state(3).s = XSteam('s_pT',steamPressure,Tmax);
    state(3).h = XSteam('h_pT',steamPressure,Tmax);
    
    %We begin the cycle at the state (3)
    pOut = XSteam('psat_T',Tcond);
    [state, Wmov]=reHeating(state,state(3),0.18,pOut,eta_siT,eta_mec,eta_gen,nF,nR);
    [state(1),~,e1,condenserLoss,~] = condenser(state(6));
    [state(2),Wop,e2,pumpLoss,ExlossP] = feedPump(state(1),steamPressure,eta_siP,eta_mec);
    [~,Qh,e3,steamGenLoss,Exloss] = steamGenerator(state(2),Tmax,eta_gen);
    
    %%%%%%%%%%%%%%%%%%%%%%%% RANKINE-HIRN CYCLE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    stateNumber = 4;
    state(stateNumber).p = 0; % preallocation
    state(stateNumber).T = 0;
    state(stateNumber).x = 0;
    state(stateNumber).h = 0;
    state(stateNumber).s = 0;
    for i=1:stateNumber-1
        state(i).p = 0;
        state(i).T = 0;
        state(i).x = 0;
        state(i).h = 0;
        state(i).s = 0;
    end
    
    % Given parameters
    state(1).T = Tcond;
    state(4).T = state(1).T;
    state(1).p=XSteam('psat_T',Tcond);
    
    %definition of the state(3) : complete !
    state(3).p = steamPressure;
    state(3).T = Tmax;
    state(3).x = nan;
    state(3).s = XSteam('s_pT',steamPressure,Tmax);
    state(3).h = XSteam('h_pT',steamPressure,Tmax);
    
    % We begin the cycle at the state (3)
    [state(4),Wmov,e4,turbineLoss,~,~] = turbine(state(3),state(1).p,eta_siT,eta_mec);
    [state(1),~,e1,condenserLoss,~] = condenser(state(4));
    [state(2),Wop,e2,pumpLoss,ExlossP] = feedPump(state(1),steamPressure,eta_siP,eta_mec);
    [~,Qh,e3,steamGenLoss,Exloss] = steamGenerator(state(2),Tmax,eta_gen);
    
    losses=[steamGenLoss, condenserLoss, turbineLoss+pumpLoss];
    
    
end

%Wmcy = Wmov+Wop; % note: Wmov<0, Wop>0

%determination of the mass flow rate of vapour
%mVapour=Pe/abs(eta_mec*Wmcy)

%eta_cyclen=Wmcy/Qh;
%eta_gen=mv*(state(3).h-state(2).h)/(mc*LHV);
% definir une fonction combustion pour def LHV et mc


disp(struct2array(state))
% M = (reshape(struct2array(state),5,stateNumber))';
% fprintf('\n')
% disp(array2table(M,'VariableNames',{'p','T','x','h','s'}))

%fprintf('Wmcy = %f kJ/kg\n\n',Wmcy)
%% PLOT

%pie chart
% h = pie([mVapour*losses,Pe]);
% hText = findobj(h,'Type','text'); % text object handles
% percentValues = get(hText,'String'); % percent values
% txt = {'Steam generator: ';'Condenser: ';'Mechanical: ';'Effective power: '};
% combinedtxt = strcat(txt,percentValues);
% set(hText,{'String'},combinedtxt);


%T-s diagram
%figure(1)
Ts_diagram(state,eta_siP,eta_siT,nF,nR)
%figure(1);
%h-s diagram
%hs_diagram(state(1),state(2),state(3),state(4),0.8,0.88)
end