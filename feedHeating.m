function[state]=feedHeating(state,pmax,eta_siP,eta_siT,nF,nR,dTpinch)
%stateO est une structure condensee contenant les etats compris entre 7 a 1

% TO DO energetic and exergetic analysis !



%% State calculation
[state(10+2*nR)]=extractionPump(state(9+2*nR),0.5,pmax,eta_siP);
for index=1:nF
    
    if nR == 0
    
    hPurge=index*abs(state(3+2*nR).h-state(8+2*nR).h)/(nF+1)+state(8+2*nR).h;
    [state(4+2*nR,index)]=bleed(index,hPurge,state(3+2*nR),eta_siT);
    elseif nR~= 0 && index==nF
    hPurge=state(4,1).h;
    [state(4+2*nR,index)]=bleed(index,hPurge,state(4,1),eta_siT);
    else
        hPurge=index*abs(state(3+2*nR).h-state(8+2*nR).h)/(nF)+state(8+2*nR).h;
        [state(4+2*nR,index)]=bleed(index,hPurge,state(3+2*nR),eta_siT);
    end
    
    [state(5+2*nR,index),~,~,~,~]=condenser(state(4+2*nR,index));
    
    if index == 1
        [state(6+2*nR,index)]=subcooler(state(5+2*nR,index),state(9+2*nR).T,dTpinch);
        inCondenser=state(8+2*nR);
        [state(7+2*nR,index)]=valve(state(6+2*nR,index),inCondenser);
    else
        previousHeater=state(5+2*nR,index-1);
        [state(6+2*nR,index)]=valve(state(5+2*nR,index),previousHeater);
    end
end

for index=1:(nF+1)
    if index == 1
        outSubcooler = state(6+2*nR,index);
        [state(11+2*nR,index)]=exchanger(state(10+2*nR),outSubcooler.T,dTpinch);
    elseif index == nF+1
        outHeater=state(5+2*nR,index-1);
        [state(1)]=exchanger(state(11+2*nR,index-1),outHeater.T,dTpinch);
    else
        outHeater=state(5+2*nR,index-1);
        [state(11+2*nR,index)]=exchanger(state(11+2*nR,index-1),outHeater.T,dTpinch);
    end
end
end
