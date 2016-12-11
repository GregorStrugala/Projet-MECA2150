function [ output_args ] = combinedCyclePowerPlant(deltaT,Triver,LPsteamPressure,HPsteamPressure,dTpinch, dTapproach,PeGT,PeST)
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
% switch nargin % Check for correct inputs, set efficiency to 1 if none is specified.
%     case 0
%         msgID = 'STEAMPOWERPLANT:NoState';
%         msg = 'Initial state must be specified.';
%         baseException = MException(msgID,msg);
%         throw(baseException)
%     case 1
%         msgID = 'STEAMPOWERPLANT:NodT';
%         msg = 'dT must be specified.';
%         baseException = MException(msgID,msg);
%         throw(baseException)
%     case 2
%         msgID = 'STEAMPOWERPLANT:NoTriver';
%         msg = 'Triver must be specified.';
%         baseException = MException(msgID,msg);
%         throw(baseException)
%     case 3
%         msgID = 'STEAMPOWERPLANT:NoTmax';
%         msg = 'Tmax must be specified.';
%         baseException = MException(msgID,msg);
%         throw(baseException)
%     case 4
%         msgID = 'STEAMPOWERPLANT:NoSteamPressure';
%         msg = 'steamPressure must be specified.';
%         baseException = MException(msgID,msg);
%         throw(baseException)
% end

% State calculations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%efficiencies
eta_mec=0.98;
eta_gen=0.945;
eta_siT=0.89;
eta_siP=0.85;

%temperature of condensation
Tcond=Triver+deltaT;

%% %%%%%%%%%%%%%%%%%%%%%% STEAM CYCLE  %%%%%%%%%%%%%%%%%%%%%%%%%
stateNumber = 9;
state(stateNumber).p = 0; %preallocation
state(stateNumber).T = 0;
state(stateNumber).x = 0;
state(stateNumber).h = 0;
state(stateNumber).s = 0;
state(stateNumber).e = 0;
for i=1:stateNumber-1
    state(i).p = 0;
    state(i).T = 0;
    state(i).x = 0;
    state(i).h = 0;
    state(i).s = 0;
    state(i).e = 0;
end

% Given parameters
state(1).T = Tcond;%in feedPump
state(1).p=XSteam('psat_T',Tcond);
state(5).T = state(1).T;
state(5).p=state(1).p

%definition of the state(3) : complete !
state(3).p = HPsteamPressure;
ToGasTurbine=570;
state(3).T = ToGasTurbine-dTapproach;
state(3).x = nan;
state(3).s = XSteam('s_pT',HPsteamPressure,state(3).T);
state(3).h = XSteam('h_pT',HPsteamPressure,state(3).T);
state(3).e = exergy(state(3));

% We begin the cycle at the state(3)
%HP part:
% [state(4),Wmov,turbineLossEn,turbineLossEx] = turbine(state(3),state(5).p,eta_siT,eta_mec);
% [state(1),Qc,condenserLossEn,condenserLossEx] = condenser(state(4));
% [state(2),Wop,pumpLossEn,pumpLossEx] = feedPump(state(1),steamPressure,eta_siP,eta_mec);
% [~,Qh,steamGenLossEn] = steamGenerator(state(2),Tmax,eta_gen);
% 
% % Warning message %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if isnan(state(4).x)||state(4).x<0.88
%     warning('Warning. The quality must be between x=[0.88, 1] to have a better efficiency.')
% end
%
%     %determination of the work over a cycle
%     Wmcy =Wmov+Wop; % note: Wmov<0, Wop>0
%     %Wmcy2=Qh-abs(Qc);
%
%     %lossEn
%     lossEn=[steamGenLossEn, condenserLossEn, turbineLossEn+pumpLossEn];
%
%     %lossEx
%     lossEx=[turbineLossEn+pumpLossEn, turbineLossEx+pumpLossEx, condenserLossEx];

%% State display in table
M = (reshape(struct2array(state),6,9))';

T = array2table(M,'VariableNames',{'p','T','x','h','s','e'});
% stateIndex = cell(stateNumber+3*nF+2*nR,1);
% for i = 1:length(stateIndex)
%     if i<5
%         stateIndex(i) = {num2str(i)};
%     elseif 5<=i && i<5+2*nR
%         if mod(i,2)~=0
%             stateIndex(i) = {[num2str((5+i)/2) ',' nums2str((i-3)/2)]};
%         else
%             stateIndex(i) =
%         end
%     end
% end
fprintf('\n')
disp(T)

%fprintf('Wmcy = %f kJ/kg\n\n',Wmcy)
end

