
function[state,WmovAdd,Wop,pumpExtractLossEn,pumpExtractLossEx,turbineLossEn,turbineLossEx,indexDeaerator]=feedHeating(state,pmax,eta_siP,eta_siT,eta_mec,nF,nR,dTpinch,deaeratorON)
%stateO est une structure condensee contenant les etats compris entre 7 a 1

% TO DO energetic and exergetic analysis !



%% State calculation
deaeratorOFF=0;
indexDeaerator=0;
%preallocations
WmovAdd=zeros(1,nF);
Wop=0;
turbineLossEn=zeros(1,nF);
turbineLossEx=zeros(1,nF);
%diffHeatingExergy=zeros(1,nF);

dPfeedPump=0.5;

for index=1:nF
    if nR==0  %no reheating
        
        %determination of the enthalpy of the bled steam
        hBleed=index*abs(state(3+2*nR).h-state(8+2*nR).h)/(nF+1)+state(8+2*nR).h;
        %work done by the bled steam (Wmov<0)
        WmovAdd(index)=hBleed-state(3+2*nR).h;
        %determination of the state of the bled steam
        [state(4+2*nR,index)]=bleed(index,hBleed,state(3),eta_siT);
        %turbine lossEn of the bled steam
        turbineLossEn(index)=abs(WmovAdd(index)*(1-eta_mec));
        %turbine lossEx of the bled steam
        turbineLossEx(index)=abs(state(4+2*nR,index).e-state(3+2*nR).e)-abs(WmovAdd(index));
        
    elseif nR~=0 && index==nF %reheating and index==nF
        
        %determination of the enthalpy of the bled steam
        hBleed=state(4,1).h; %le dernier soutirage a lieu au niveau du reheating (voir p.89)
        %work done by the bled steam at the last bleed (Wmov<0)
        WmovAdd(index)=hBleed-state(3).h;
        %determination of the state of the bled steam
        [state(4+2*nR,index)]=bleed(index,hBleed,state(4,1),eta_siT);
        
    else % nR~=0 and index~=nF
        
        %determination of the enthalpy of the bled steam;
        
        %NOTE : dans la formule pour hBleed, on ne divise pas par (nF+1).
        %Et c'est volontaire! Si nR~=0 alors on a un soutirage au niveau de
        %la rechauffe (lors de la detente partielle de la turbine) donc il reste (nF-1) soutirage sur l'expansion totale
        %dans la turbine. On a donc (...)/((nF-1)+1) = /nF :)
        hBleed=index*abs(state(3+2*nR).h-state(8+2*nR).h)/(nF)+state(8+2*nR).h;
        
        %work done by the bled steam
        WmovAdd(index)=hBleed-state(3+2*nR).h;
        %determination of the state of the bled steam
        [state(4+2*nR,index)]=bleed(index,hBleed,state(3+2*nR),eta_siT);
    end
    Tsat=XSteam('Tsat_p',state(4+2*nR,index).p);
    if deaeratorON && Tsat>120 && nF>2 %condition supp necessaire ???
        indexDeaerator=index;
        deaeratorON=0;
        deaeratorOFF=1;
        [state(5+2*nR,index), ~]=deaerator(state(4+2*nR,index),Tsat);
        %state that correspond to the out of the valve. There is no valve so we put this equals to 0
        %state(6+2*nR,indexDeaerator)=0;
    else
        %condensation of the bled steam in the heater : exchange with the fluid
        %coming from the extracting pump
        [state(5+2*nR,index),~,~,~]=condenser(state(4+2*nR,index));
        %exergetic loss of this function are take into account in
        %diffHeatingExergy : exchange with heating fluid (fluid coming from
        %the turbine and the heated fluid : fluid coming from the
        %extracting pump).
        
        if index==1 %case of the first feed heating (adding a subcooler)
            [state(6+2*nR,index)]=subcooler(state(5+2*nR,index),state(9+2*nR).T,dTpinch);
            
            %diffHeatingExergy(index)=state(6+2*nR,index).e-state(4+2*nR,index).e;
            %isenthalpic expansion in the valve
            inCondenser=state(8+2*nR);
            [state(7+2*nR,index)]=valve(state(6+2*nR,index),inCondenser);
        elseif index==indexDeaerator
            %... do nothing
        else %case of 'typical' feed heating (no subcooler)
            %isenthalpic expansion in the valve
            previousHeater=state(5+2*nR,index-1);%to determine the pressure and the temperature of the out state
            [state(6+2*nR,index)]=valve(state(5+2*nR,index),previousHeater);
            %diffHeatingExergy(index)=state(5+2*nR,index).e-state(4+2*nR,index).e;
        end
    end
end
%determination of the output of the extracting pump: if there is a
%deaerator, then the pressure at the output of the extracting pump must be
%equal to the pressure coming from the turbine (bled steam) into the
%deaerator.
if Tsat>120 && deaeratorOFF %if there is a deaerator
    %compression ratio
    dPextract=(state(4+2*nR,index).p)/pmax;
    [state(10+2*nR),WopExtract,pumpExtractLossEn,pumpExtractLossEx]=extractionPump(state(9+2*nR),dPextract,pmax,eta_siP,eta_mec);
    Wop=Wop+WopExtract;
elseif deaeratorON && Tsat<120 %no deaerator
    %compression ratio
    dP=(1-dPfeedPump);
    %out of the extracting pump after heaters
    [state(10+2*nR),WopExtract,pumpExtractLossEn,pumpExtractLossEx]=extractionPump(state(9+2*nR),dP,pmax,eta_siP,eta_mec);
    Wop=Wop+WopExtract;
else %no deaerator
    %compression ratio
    dP=(1-dPfeedPump);
    %out of the extracting pump after heaters
    [state(10+2*nR),WopExtract,pumpExtractLossEn,pumpExtractLossEx]=extractionPump(state(9+2*nR),dP,pmax,eta_siP,eta_mec);
    Wop=Wop+WopExtract;
end

%calculation of the state of the fluid coming from the extracting pump
%after each exchange with the fuid coming from the turbine in the different
%heater.
for index=1:(nF+1)
    if index == 1 %case of the first feed heating : exchange with the subcooler
        outSubcooler = state(6+2*nR,index);
        %[state(11+2*nR,index)]=exchanger(state(10+2*nR),outSubcooler.T,dTpinch);
        [state(11+2*nR,index)]=exchanger(state(10+2*nR),outSubcooler.T,3);
    elseif index == nF+1 %last exchanger before the feed pump (state(11+2*nR,nF+1)=state(1))
        outHeater=state(5+2*nR,index-1);
        [state(1)]=exchanger(state(11+2*nR,index-1),outHeater.T,dTpinch);
    elseif index == indexDeaerator+1
        dPoutDeae=1-(dPfeedPump+dPextract);
        %mettre extracting pump --> donne le nouvel etat
        [state(11+2*nR,index),WopExtract,pumpExtractLossEn, pumpExtractLossEx]=extractionPump(state(5+2*nR,indexDeaerator),dPoutDeae,pmax,eta_siP,eta_mec);
        Wop=Wop+WopExtract;
    else %case of 'typical' feed heating exchange with a heater(no subcooler)
        outHeater=state(5+2*nR,index-1);
        [state(11+2*nR,index)]=exchanger(state(11+2*nR,index-1),outHeater.T,dTpinch);
    end
end
end
