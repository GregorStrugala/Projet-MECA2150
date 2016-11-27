function[state,WmovAdd,Wop,pumpExtractLossEn,pumpExtractLossEx,turbineLossEn,turbineLossEx,diffHeatingExergy]=feedHeating(state,pmax,eta_siP,eta_siT,eta_mec,nF,nR,dTpinch)
%stateO est une structure condensee contenant les etats compris entre 7 a 1

% TO DO energetic and exergetic analysis !



%% State calculation

%preallocations
WmovAdd=zeros(1,nF);
turbineLossEn=zeros(1,nF);
turbineLossEx=zeros(1,nF);
diffHeatingExergy=zeros(1,nF);

%out of the extracting pump
[state(10+2*nR),Wop,pumpExtractLossEn, pumpExtractLossEx]=extractionPump(state(9+2*nR),0.5,pmax,eta_siP,eta_mec);
for index=1:nF
    if nR == 0  %no reheating   
        %determination of the enthalpy of the bled steam
        hPurge=index*abs(state(3+2*nR).h-state(8+2*nR).h)/(nF+1)+state(8+2*nR).h;
        %work done by the bled steam
        WmovAdd(index)=hPurge-state(3+2*nR).h;
        %determination of the state of the bled steam
        [state(4+2*nR,index)]=bleed(index,hPurge,state(3+2*nR),eta_siT);
        %turbine lossEn of the bled steam
        turbineLossEn(index)=abs(WmovAdd(index)*(1-eta_mec));
        %turbine lossEx of the bled steam
        turbineLossEx(index)=abs(state(4+2*nR,index).e-state(3+2*nR).e)-abs(WmovAdd(index));
    elseif nR~= 0 && index==nF %reheating and index == nF
        %determination of the enthalpy of the bled steam
        hPurge=state(4,1).h; %le dernier soutirage a lieu au niveau du reheating (voir p.89)
        %work done by the bled steam
        WmovAdd(index)=hPurge(index)-state(3);
        %determination of the state of the bled steam
        [state(4+2*nR,index)]=bleed(index,hPurge,state(4,1),eta_siT);
    else % nR ~= 0 and index~=nF
        %determination of the enthalpy of the bled steam
        hPurge=index*abs(state(3+2*nR).h-state(8+2*nR).h)/(nF)+state(8+2*nR).h;
        %work done by the bled steam
        WmovAdd(index)=hPurge-state(3+2*nR);
        %determination of the state of the bled steam
        [state(4+2*nR,index)]=bleed(index,hPurge,state(3+2*nR),eta_siT);
    end
    %condensation of the bled steam in the heater : exchange with the fluid
    %coming from the extracting pump
    [state(5+2*nR,index),~,~,~]=condenser(state(4+2*nR,index));
    
    %NOTE:diffHeatingExergy is the exergy difference of the heating
    %fluid during in the heater (exchange with the fluid coming from the
    %extracting pump) --> to calculate ; heatLossEx (see steamPowerPlant)
    
    if index == 1 %case of the first feed heating (adding a subcooler)
        [state(6+2*nR,index)]=subcooler(state(5+2*nR,index),state(9+2*nR).T,dTpinch);
        
        diffHeatingExergy(index)=state(6+2*nR,index).e-state(4+2*nR,index).e;
        %isenthalpic expansion in the valve
        inCondenser=state(8+2*nR);
        [state(7+2*nR,index)]=valve(state(6+2*nR,index),inCondenser);
    else %case of 'typical' feed heating (no subcooler)
         %isenthalpic expansion in the valve
        previousHeater=state(5+2*nR,index-1);
        [state(6+2*nR,index)]=valve(state(5+2*nR,index),previousHeater);
        diffHeatingExergy(index)=state(5+2*nR,index).e-state(4+2*nR,index).e;
    end
end

%calculation of the state of the fluid coming from the extracting pump
%after each exchange with the fuid coming from the turbine in the different
%heater.
for index=1:(nF+1)
    if index == 1 %case of the first feed heating : exchange with the subcooler
        outSubcooler = state(6+2*nR,index);
        [state(11+2*nR,index)]=exchanger(state(10+2*nR),outSubcooler.T,dTpinch);
    elseif index == nF+1 %last exchanger before the feed pump (state(11+2*nR,nF+1)=state(1))
        outHeater=state(5+2*nR,index-1);
        [state(1)]=exchanger(state(11+2*nR,index-1),outHeater.T,dTpinch);
    else %case of 'typical' feed heating exchange with a heater(no subcooler)
        outHeater=state(5+2*nR,index-1);
        [state(11+2*nR,index)]=exchanger(state(11+2*nR,index-1),outHeater.T,dTpinch);
    end
end
end
