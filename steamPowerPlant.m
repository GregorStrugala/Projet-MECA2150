function steamPowerPlant(deltaT, Triver, Tmax, steamPressure, Pe, n)
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

eta_mec=0.9;

if n==0
    stateNumber = 4;
else
    stateNumber=4+2+4*n;
end
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

Tcond=Triver+deltaT;

if n==0 %there is no feedHeating
    
    % Given parameters
    state(1).T = Tcond;
    state(4).T = state(1).T;
    state(3).p = steamPressure;
    state(3).T = Tmax;
    
    % We begin the cycle at the state (3)
    [state(4),state(3),Wmov,e4,ExLossT,turbineLoss,eta_turbex] = turbine(state(3),Tcond,0.88,0.9);
    [state(1),~,e1,condenserLoss,~] = condenser(state(4));
    [state(2),Wop,e2,pumpLoss,ExlossP] = feedPump(state(1),steamPressure,0.8,0.85);
    [Qh,e3,steamGenLoss,Exloss] = steamGenerator(state(2),Tmax,0.945);
    
else
    
    % Given parameters
    state(5).T = Tcond;
    state(4).T = state(5).T;
    state(3).p = steamPressure;
    state(3).T = Tmax;
    
    % We begin the cycle at the state (3)
    [state(4),state(3),Wmov,e4,ExLossT,turbineLoss,eta_turbex] = turbine(state(3),Tcond,0.88,0.9);
    [state(5),~,e1,condenserLoss,~] = condenser(state(4));
    [state]=feedHeating(state,steamPressure,0.8,0.88,n); %to do energetic and exergetic analysis
    [state(2),Wop,e2,pumpLoss,ExlossP] = feedPump(state(1),steamPressure,0.8,0.85);
    [Qh,e3,steamGenLoss,Exloss] = steamGenerator(state(2),Tmax,0.945);
    
end

Wmcy = Wmov+Wop; % note: Wmov<0, Wop>0

%determination of the mass flow rate of vapour
mVapour=Pe/(eta_mec*Wmcy);

eta_cyclen=Wmcy/Qh;
%eta_gen=mv*(state(3).h-state(2).h)/(mc*LHV);
% definir une fonction combustion pour def LHV et mc

M = (reshape(struct2array(state),5,stateNumber))';
fprintf('\n')
disp(array2table(M,'VariableNames',{'p','T','x','h','s'}))

fprintf('Wmcy = %f kJ/kg\n\n',Wmcy)

Ts_diagram(state,0.8,0.88,n)
%figure(1);
%hs_diagram(state(1),state(2),state(3),state(4),0.8,0.88)
end