function[state,Wmov,Qh,turbineLossEn,turbineLossEx]=reHeating(state,stateI,r,pOut,eta_siT,turbineEfficiency,eta_gen,nF,nR,CCPP)
%REHEATING
%% State calculation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pI = stateI.p;
Ti = stateI.T;
%xI = stateI.x;
%hI = stateI.h;
%sI = stateI.s;

if nF == 0
    %pO=r*pI;
    [state(4,1),Wmov1,turbineLossEn1,turbineLossEx1] = turbine(stateI,r*pI,eta_siT,turbineEfficiency);
    %fictive expansion:
    [state(4,2),~,~,~] = turbine(stateI,pOut,eta_siT,turbineEfficiency);
    
    [state(5),Qh,~] = steamGenerator(state(4,1),Ti,eta_gen);
    [state(6+CCPP),Wmov2,turbineLossEn2,turbineLossEx2] = turbine(state(5),pOut,eta_siT,turbineEfficiency);
else
    [state(4,1),Wmov1,turbineLossEn1,turbineLossEx1] = turbine(stateI,r*pI,eta_siT,turbineEfficiency);
    %fictive expansion:
    [state(4,2),~,~,~] = turbine(stateI,pOut,eta_siT,turbineEfficiency);
    
    [state(5),Qh,~] = steamGenerator(state(4,1),Ti,eta_gen);
    [state(8+2*nR),Wmov2,turbineLossEn2,turbineLossEx2] = turbine(state(5),pOut,eta_siT,turbineEfficiency);
end
Wmov=Wmov1+Wmov2;
turbineLossEn=turbineLossEn1+turbineLossEn2;
turbineLossEx=turbineLossEx1+turbineLossEx2;
end