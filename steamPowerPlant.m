function steamPowerPlant(deltaT,Triver,Tmax,steamPressure,Pe,nF,nR,dTpinch,deaeratorON,diagrams,pieChart)
%NEWSTRUCT
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

% State calculations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
indexDeaerator=0;
X=0;
%efficiencies
eta_mec=0.98;
eta_gen=0.945;
eta_siT=0.89;
eta_siP=0.85;

%temperature of condensation
Tcond=Triver+deltaT;

if nR==0 && nF==0
    %% %%%%%%%%%%%%%%%%%%%%%% RANKINE-HIRN CYCLE  %%%%%%%%%%%%%%%%%%%%%%%%%
    stateNumber = 4;
    state(stateNumber).p = []; %preallocation
    state(stateNumber).T = [];
    state(stateNumber).x = [];
    state(stateNumber).h = [];
    state(stateNumber).s = [];
    state(stateNumber).e = [];
    for i=1:stateNumber-1
        state(i).p = [];
        state(i).T = [];
        state(i).x = [];
        state(i).h = [];
        state(i).s = [];
        state(i).e = [];
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
    state(3).e = exergy(state(3));
    
    % We begin the cycle at the state(3)
    [state(4),Wmov,turbineLossEn,turbineLossEx] = turbine(state(3),state(1).p,eta_siT,eta_mec);
    [state(1),Qc,condenserLossEn,condenserLossEx] = condenser(state(4));
    [state(2),Wop,pumpLossEn,pumpLossEx] = feedPump(state(1),steamPressure,eta_siP,eta_mec);
    [~,Qh,steamGenLossEn] = steamGenerator(state(2),Tmax,eta_gen);
    
    %determination of the work over a cycle
    Wmcy =Wmov+Wop; % note: Wmov<0, Wop>0
    %Wmcy2=Qh-abs(Qc);
    
    %lossEn
    lossEn=[steamGenLossEn, condenserLossEn, turbineLossEn+pumpLossEn];
    
    %lossEx
    lossEx=[turbineLossEn+pumpLossEn, turbineLossEx+pumpLossEx, condenserLossEx];
    
elseif  nR > 0 && nF == 0
    %%   %%%%%%%%%%%%%%%%%%%%%%%%% REHEATING ONLY %%%%%%%%%%%%%%%%%%%%%%%%%
    stateNumber=4+2*nR;
    state(stateNumber,nR+1).p = []; %preallocation
    state(stateNumber,nR+1).T = [];
    state(stateNumber,nR+1).x = [];
    state(stateNumber,nR+1).h = [];
    state(stateNumber,nR+1).s = [];
    state(stateNumber,nR+1).e = [];
    for i=1:stateNumber-1
        for j=1:nR
            state(i,j).p = [];
            state(i,j).T = [];
            state(i,j).x = [];
            state(i,j).h = [];
            state(i,j).s = [];
            state(i,j).e = [];
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
    state(3).e = exergy(state(3));
    
    %We begin the cycle at the state (3)
    pOut = XSteam('psat_T',Tcond);
    [state, Wmov,QreHeat,turbineLossEn,turbineLossEx]=reHeating(state,state(3),0.15,pOut,eta_siT,eta_mec,eta_gen,nF,nR);
    [state(1),Qc,~,condenserLossEx] = condenser(state(6));
    [state(2),Wop,pumpLossEn,pumpLossEx] = feedPump(state(1),steamPressure,eta_siP,eta_mec);
    [~,QsteamGen,~] = steamGenerator(state(2),Tmax,eta_gen);
    
    %TO BE MODIFIED !!!
    %determination of the work over a cycle
    Wmcy =Wmov+Wop; % note: Wmov<0, Wop>0
    Qh=QreHeat+QsteamGen;
    %Wmcy2=Qh-abs(Qc);
    %lossEn
    
    %lossEx
    lossEx=[turbineLossEn+pumpLossEn,turbineLossEx+pumpLossEx,condenserLossEx];
    
else
    %% %%%%%%%%%%%%%%%%%%%% COMBINING, FEEDHEATING ONLY %%%%%%%%%%%%%%%%%%%%%%%
    stateNumber=11+2*nR; %independent of nF!
    state(stateNumber,nF).p = []; %preallocation
    state(stateNumber,nF).T = [];
    state(stateNumber,nF).x = [];
    state(stateNumber,nF).h = [];
    state(stateNumber,nF).s = [];
    state(stateNumber,nF).e = [];
    for i=1:stateNumber-1
        for j=1:nF
            state(i,j).p = [];
            state(i,j).T = [];
            state(i,j).x = [];
            state(i,j).h = [];
            state(i,j).s = [];
            state(i,j).e = [];
        end
    end
    % Given parameters
    state(8+2*nR).T = Tcond;
    state(8+2*nR).p = XSteam('psat_T',Tcond);
    
    %definition of the state(3) : complete !
    state(3).p = steamPressure;
    state(3).T = Tmax;
    state(3).x = nan;
    state(3).s = XSteam('s_pT',steamPressure,Tmax);
    state(3).h = XSteam('h_pT',steamPressure,Tmax);
    state(3).e = exergy(state(3));
    
    % We begin the cycle at the state(3)
    if nR == 0 %case without re-heating
        QreHeat=0;
        [state(8),WmovTurb,turbineLossEn,turbineLossEx]=turbine(state(3),state(8).p,eta_siT,eta_mec);
    else %case with re-heating
        pOut = XSteam('psat_T',Tcond);
        [state,WmovTurb,QreHeat,turbineLossEn,turbineLossEx]=reHeating(state,state(3),0.18,pOut,eta_siT,eta_mec,eta_gen,nF,nR);
    end
    [state(9+2*nR),Qc,~,condenserLossEx]=condenser(state(8+2*nR));
    [state,WmovAdd,WopExtractPump,extractPumpLossEn,extractPumpLossEx,turbineBleedLossEn,turbineBleedLossEx,indexDeaerator]=feedHeating(state,steamPressure,eta_siP,eta_siT,eta_mec,nF,nR,dTpinch,deaeratorON); %to do energetic and exergetic analysis
    [state(2),WopFeedPump,feedPumpLossEn,feedPumpLossEx]=feedPump(state(1),steamPressure,eta_siP,eta_mec);
    [~,QsteamGen,~]=steamGenerator(state(2),Tmax,eta_gen);
    [X]=bleedFraction(state,nF,nR,indexDeaerator)
     
    %work done on the cycle
    Wmov=WmovTurb+WmovAdd*X; %turbine (note : Wmov is line vector; X is column vector)
    Wop=(1+sum(X))*(WopFeedPump+WopExtractPump);%pumps (feed pump and extracting pump)
    
    %determination of the work over a cycle
    Wmcy=Wmov+Wop;%note: Wmov<0, Wop>0
    Qh=QreHeat+QsteamGen;
    Wmcy2=(1+sum(X))*Qh-abs(Qc);
    
    %lossEn
    if indexDeaerator~=0
        extractPumpLossEn=(1+sum(X(1:indexDeaerator-1)))*extractPumpLossEn;
        pumpLossEn=(feedPumpLossEn)*(1+sum(X))+extractPumpLossEn;
    else
        pumpLossEn=(feedPumpLossEn+extractPumpLossEn)*(1+sum(X));
    end
    turbineLossEn=turbineLossEn+turbineBleedLossEn*X;
    
    %lossEx
    if indexDeaerator~=0
        extractPumpLossEx=(1+sum(X(1:indexDeaerator-1)))*extractPumpLossEx;
        pumpLossEx=(feedPumpLossEx)*(1+sum(X))+extractPumpLossEx;
    else
        pumpLossEx=(feedPumpLossEx+extractPumpLossEx)*(1+sum(X));
    end
    %pumpLossEx2=(pumpLossEx+extractPumpLossEx)*(1+sum(X))
    turbineLossEx=turbineLossEx+turbineBleedLossEx*X;
    
end

%% FLOW RATES
%determination of the mass flow rate of vapour
if nR==0 && nF==0
    mVapourSteamGen=Pe/abs(eta_mec*Wmcy);
    [eta_combex,eta_gen,mc,e_exh,ec,ef,LHV]=combustion('CH4',1.05,120+273.15,15+273.15,0.01,mVapourSteamGen*(state(3).h-state(2).h));
    er=0.04;
    mf=eta_combex*mc*ec/(ef-er);
elseif nR~=0 && nF==0
    mVapourSteamGen=Pe/abs(eta_mec*Wmcy);
    [eta_combex,eta_gen,mc,e_exh,ec,ef,LHV]=combustion('CH4',1.05,120+273.15,15+273.15,0.01,mVapourSteamGen*((state(3).h-state(2).h)+state(5).h-state(4,1).h));
    er=0.04;
    mf=eta_combex*mc*ec/(ef-er);
else
    er=0.04;
    %definition of the different flow rate
    mVapourCond=Pe/abs(eta_mec*Wmcy);
    mVapourBleed=mVapourCond*X
    mVapourSteamGen=(1+sum(X))*mVapourCond;
    if nR==0
        [eta_combex,eta_gen,mc,e_exh,ec,ef,LHV]=combustion('CH4',1.05,120+273.15,15+273.15,0.01,mVapourSteamGen*(state(3).h-state(2).h));
    else 
        [eta_combex,eta_gen,mc,e_exh,ec,ef,LHV]=combustion('CH4',1.05,120+273.15,15+273.15,0.01,mVapourSteamGen*((state(3).h-state(2).h)+state(5).h-state(4,1).h));
    end
    mf=eta_combex*mc*ec/(ef-er);
end

%% EFFICIENCIES
%A TRIER !!! FAIRE UN TABLEAU QUI AFFICHE

if nR==0 && nF==0 %R-H cycle
    %ENERGY
    %energetic efficiency of the cycle
    eta_cyclen=abs(Wmcy)/(Qh);%NOTE : Wmcy<0
    %eta_cyclen2=(Qh-abs(Qc))/(Qh);
    %total energetic efficiency of the plant
    eta_toten=Pe/(mc*LHV)
    %eta_toten2=eta_gen*eta_mec*eta_cyclen
    
    %EXERGY
    eIsteamGen=exergy(state(2));
    eOsteamGen=exergy(state(3));
    %exegertic efficiency of the cycle (R-H, feed-heating)
    eta_cyclex=abs(Wmcy)/(eOsteamGen-eIsteamGen);
    %total exergetic efficiency of the plant
    eta_totex=Pe/(mc*ec);
    %efficiency related to exergy output at the stack
    eta_chimnex=(ef-e_exh)/(ef-er);
    %exergetic efficiency of the heat transfer (flue gas/working fluid)
    eta_transex=mVapourSteamGen*(eOsteamGen-eIsteamGen)/(mf*(ef-e_exh));
    %eta_transex2=mVapourSteamGen*(eOsteamGen-eIsteamGen)/(eta_combex*eta_chimnex*mc*ec);
    %exergetic efficiency of the steam generator
    eta_gex=mVapourSteamGen*(eOsteamGen-eIsteamGen)/(mc*ec);
    %eta_gex2=eta_transex*eta_chimnex*eta_combex;

elseif nR~=0 && nF ==0 %reheating only  
    %ENERGY
    eta_cyclen=abs(Wmcy)/(Qh);
    %eta_cyclen2=(Qh-abs(Qc))/(Qh);
    
    %EXERGY
    eIsteamGen1=exergy(state(2));
    eOsteamGen1=exergy(state(3));
    eIsteamGen2=exergy(state(4,1));
    eOsteamGen2=exergy(state(5));
    %exegertic efficiency of the cycle (R-H, feed-heating)
    eta_cyclex=abs(Wmcy)/(eOsteamGen1+eOsteamGen2-(eIsteamGen1+eIsteamGen2));
    %total exergetic efficiency of the plant
    eta_totex=Pe/(mc*ec);
    %efficiency related to exergy output at the stack
    eta_chimnex=(ef-e_exh)/(ef-er);
    %exergetic efficiency of the heat transfer (flue gas/working fluid)
    eta_transex=mVapourSteamGen*(eOsteamGen1+eOsteamGen2-(eIsteamGen1+eIsteamGen2))/(mf*(ef-e_exh));
    %eta_transex2=mVapourSteamGen*(eOsteamGen1+eOsteamGen2-(eIsteamGen1+eIsteamGen2))/(eta_combex*eta_chimnex*mc*ec);
    %exergetic efficiency of the steam generator
    eta_gex=mVapourSteamGen*(eOsteamGen1+eOsteamGen2-(eIsteamGen1+eIsteamGen2))/(mc*ec);
    eta_gex2=eta_transex*eta_chimnex*eta_combex;
    
else %feed-heating or combining
    %ENERGY
    %energetic efficiency of the cycle
    %ILS SONT DIFFERENTS --> PAS NORMAL !
    eta_cyclen=abs(Wmcy)/((1+sum(X))*Qh);%NOTE : Wmcy<0
    eta_cyclen2=((1+sum(X))*Qh-abs(Qc))/((1+sum(X))*Qh);
    %total energetic efficiency of the plant
    eta_toten=Pe/(mc*LHV);
    %eta_toten2=eta_gen*eta_mec*eta_cyclen;
    
    %EXERGY
    eIsteamGen=exergy(state(2));
    eOsteamGen=exergy(state(3));
    %exegertic efficiency of the cycle (R-H, feed-heating)
    eta_cyclex=abs(Wmcy)/((1+sum(X))*(eOsteamGen-eIsteamGen));
    %total exergetic efficiency of the plant
    eta_totex=Pe/(mc*ec);
    %efficiency related to exergy output at the stack
    eta_chimnex=(ef-e_exh)/(ef-er);
    %exergetic efficiency of the heat transfer (flue gas/working fluid)
    eta_transex=mVapourSteamGen*(eOsteamGen-eIsteamGen)/(mf*(ef-e_exh));
    eta_transex2=mVapourSteamGen*(eOsteamGen-eIsteamGen)/(eta_combex*eta_chimnex*mc*ec);
    %exergetic efficiency of the steam generator
    eta_gex=mVapourSteamGen*(eOsteamGen-eIsteamGen)/(mc*ec);
    eta_gex2=eta_transex*eta_chimnex*eta_combex;
end
%energetic efficiency of the steam generator
eta_gen;
%mechanical efficiency of the plant
eta_mec;
%exergetic efficiency of the combustion
eta_combex;

%% PIE CHART
if pieChart
    %%%%%%%%%%%%%%%%%%%%%%%% RANKINE-HIRN CYCLE %%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nR==0 && nF==0
        er=0.04;
        %Energy pie chart
        figure(1);
        h = pie([mVapourSteamGen*lossEn,Pe]);
        hText = findobj(h,'Type','text'); % text object handles
        percentValues = get(hText,'String'); % percent values
        txt = {'Steam generator losses: ';'Condenser loss: ';'Mechanical losses: ';'Effective power: '};
        combinedtxt = strcat(txt,percentValues);
        set(hText,{'String'},combinedtxt);
        legend(txt);
        
        % lossEx :
        combLossEx=mc*ec*(1-eta_combex);
        chimneyLossEx=mf*(ef-er)-mf*(ef-e_exh);
        transLossEx=mf*(ef-e_exh)-mVapourSteamGen*(state(3).e-state(2).e);
        steamGenLossEx=[combLossEx, chimneyLossEx, transLossEx];
        
        %Exergy pie chart
        figure(2);
        lossEx=mVapourSteamGen*lossEx;
        lossEx=[lossEx,steamGenLossEx];
        h = pie([lossEx,Pe]);
        hText = findobj(h,'Type','text'); % text object handles
        percentValues = get(hText,'String'); % percent values
        txt = {'Mechanical losses: ';'Irreversibilities in the turbine and pumps: ';'Condenser losses: ';'Combustion irreversibility: ';'Chimney loss: ';'Heat transfer irreversibility in the steam generator: ';'Effective power: '};
        combinedtxt = strcat(txt,percentValues);
        set(hText,{'String'},combinedtxt);
        legend(txt);
        
        %%%%%%%%%%%%%%%%%%%%%%%% REHEATING ONLY %%%%%%%%%%%%%%%%%%%%%%%%%%%
    elseif nF==0 && nR ~=0
        %Energy
        
        %lossEx :
        combLossEx=mc*ec*(1-eta_combex);
        chimneyLossEx=mf*(ef-er)-mf*(ef-e_exh);
        transLossEx=mf*(ef-e_exh)-(mVapourSteamGen*(state(3).e-state(2).e+state(5).e-state(4,1).e));
        steamGenLossEx=[combLossEx, chimneyLossEx, transLossEx];
        
        %Exergy
        figure(2);
        %[mVapourSteamGen*lossEx,steamGenLossEx,Pe];
        h = pie([mVapourSteamGen*lossEx,steamGenLossEx,Pe]);
        hText = findobj(h,'Type','text'); % text object handles
        percentValues = get(hText,'String'); % percent values
        txt = {'Mechanical losses : ';'Irreversibilities in the turbine and pumps : ';'Condenser losses : ';'combex: ';'chimnex: ';'transex: ';'Effective power: '};
        %txt = {'Mechanical: ';'turbine and pumps: ';'condenser :';'combex: ';'chimnex: ';'transex: ';'Effective power: '};
        combinedtxt = strcat(txt,percentValues);
        set(hText,{'String'},combinedtxt);
        legend(txt);
        
        %%%%%%%%%%%%%%%%%%%% COMBINING, FEEDHEATING ONLY %%%%%%%%%%%%%%%%%%
    else
        er=0.04;
        
        %lossEx :
        mecLossEn=(pumpLossEn+turbineLossEn)*mVapourCond%OK
        pumpTurbLossEx=(pumpLossEx+turbineLossEx)*mVapourCond%OK
        condenserLossEx=mVapourCond*condenserLossEx
        if nF==0
            transLossEx=mf*(ef-e_exh)-(mVapourSteamGen*(state(3).e-state(2).e))
        else
            transLossEx=mf*(ef-e_exh)-(mVapourSteamGen*(state(3).e-state(2).e+state(5).e-state(4,1).e))
        end
        
        combLossEx=mc*ec*(1-eta_combex)
        chimneyLossEx=mf*(ef-er)-mf*(ef-e_exh)
        %transLossEx=mf*(ef-e_exh)-mVapourSteamGen*(state(3).e-state(2).e);
        
        diffExergyHeatingFluid=0;
        for i=1:nF
            if i==nF
                diffExergyHeatingFluid=diffExergyHeatingFluid+X(i)*abs(state(5+2*nR,i).e-state(4+2*nR,i).e);
            elseif i==1 && nF>1
                diffExergyHeatingFluid=diffExergyHeatingFluid+abs(sum(X)*state(6+2*nR,i).e-(X(i)*state(4+2*nR,i).e+(sum(X)-X(i))*state(6+2*nR,i+1).e));
            else
                diffExergyHeatingFluid=diffExergyHeatingFluid+abs((sum(X(i+1:end))+X(i))*state(5+2*nR,i).e-(X(i)*state(4+2*nR,i).e+(sum(X(i+1:end)))*state(6+2*nR,i+1).e));
            end
        end
        heatLossEx=mVapourCond*diffExergyHeatingFluid-mVapourSteamGen*abs(state(1).e-state(10+2*nR,1).e);
        %lossEx in the steam generator : combex, chimnex, transex
        steamGenLossEx=[combLossEx, chimneyLossEx, transLossEx];
        %lossEx total:
        lossEx=[mecLossEn,pumpTurbLossEx,condenserLossEx,heatLossEx,steamGenLossEx];
        
%         %Exergy
%         figure(2);
%         h = pie([lossEx,Pe]);
%         hText = findobj(h,'Type','text'); % text object handles
%         percentValues = get(hText,'String'); % percent values
%         txt = {'Mechanical losses: ';'Irreversibilities in the turbine and pumps: ';'Condenser loss: ';'Heat transfer irreversibilities in the feed-water heater: ';'Combustion irreversibility: ';'Chimney loss: ';'Heat transfer irreversibility in the steam generator: ';'Effective power: '};
%         %txt = {'Mechanical: ';'turbine and pumps: ';'condenser :';'combex: ';'chimnex: ';'transex: ';'Effective power: '};
%         combinedtxt = strcat(txt,percentValues);
%         set(hText,{'String'},combinedtxt);
%         legend(txt);
    end
end

% %% State display in table
% if nR==0 && nF==0 %Rankine-Hirn cycle
%     M = (reshape(struct2array(state),6,4))';
% elseif nR~=0 && nF==0
%     M = (reshape(struct2array(state),6,(stateNumber + nR)))';
% else %R-H cycle with feed-heating and/or re-heating
%     M = (reshape(struct2array(state),6,(stateNumber + nR + 4*(nF-1))))';
% end
% T = array2table(M,'VariableNames',{'p','T','x','h','s','e'});
% % stateIndex = cell(stateNumber+3*nF+2*nR,1);
% % for i = 1:length(stateIndex)
% %     if i<5
% %         stateIndex(i) = {num2str(i)};
% %     elseif 5<=i && i<5+2*nR
% %         if mod(i,2)~=0
% %             stateIndex(i) = {[num2str((5+i)/2) ',' nums2str((i-3)/2)]};
% %         else
% %             stateIndex(i) =
% %         end
% %     end
% % end
% disp(T)
% fprintf('\n')
% 
% %fprintf('Wmcy = %f kJ/kg\n\n',Wmcy)

%% DIAGRAMS : TS and HS
if diagrams
    %T-s diagram
    %figure(3)
    Ts_diagram(state,eta_siP,eta_siT,nF,nR,deaeratorON,indexDeaerator)
    %figure(1);
    %h-s diagram
    %hs_diagram(state(1),state(2),state(3),state(4),0.8,0.88)
end
end