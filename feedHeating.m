function[state]=feedHeating(state,pmax,eta_siP,eta_siT,nF,dTpinch)
%stateO est une structure condensee contenant les etats compris entre 7 a 1

% TO DO energetic and exergetic analysis !



%% State calculation
for index=1:nF
    
    hPurge=index*abs(state(3).h-state(8).h)/(nF+1)+state(8).h;
    
    [state(10)]=extractionPump(state(9),0.5,pmax,eta_siP);
    [state(4,index)]=bleed(index,hPurge,state(3),eta_siT);
    [state(5,index),~,~,~,~]=condenser(state(4,index));
    
    if index == 1
        [state(6,index)]=subcooler(state(5,index),state(9).T);
        inCondenser=state(8);
        [state(7,index)]=valve(state(6,index),inCondenser);
    else
        previousHeater=state(5,index-1);
        [state(6,index)]=valve(state(5,index),previousHeater);
    end
end

for index=1:(nF+1)
    if index == 1
        outSubcooler = state(6,index);
        [state(11,index)]=exchanger(state(10),outSubcooler.T,dTpinch);
    elseif index == nF+1
        outHeater=state(5,index-1);
        [state(1)]=exchanger(state(11,index-1),outHeater.T,dTpinch);
    else
        outHeater=state(5,index-1);
        [state(11,index)]=exchanger(state(11,index-1),outHeater.T,dTpinch);
    end
end
end
