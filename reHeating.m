function[state,Wmov]=reHeating(state,stateI,r,pOut,eta_siT,turbineEfficiency,eta_gen)
%REHEATING
%% State calculation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pI = stateI.p;
Ti = stateI.T;
xI = stateI.x;
hI = stateI.h;
sI = stateI.s;


%pO=r*pI;

[state(4),Wmov,~,~,~,~] = turbine(stateI,pOut,eta_siT,turbineEfficiency);
[state(5),Wmov,~,~,~,~] = turbine(stateI,r*pI,eta_siT,turbineEfficiency);
[state(6),~,~,~,~] = steamGenerator(state(5),Ti,eta_gen);
[state(7),Wmov,~,~,~,~] = turbine(state(6),pOut,eta_siT,turbineEfficiency);
% stateO1=state(4);
% stateO2=state(5);





% stateO.p = pO;
% stateO.T = To;
% stateO.x = xO;
% stateO.h = hO;
% stateO.s = sO;
end