function steamPowerPlant(deltaT,Triver,Tmax,steamPressure,Pe,nF,nR,dTpinch,deaeratorON,fuel,excessAir,TflueGas,Tambiant,diagrams)
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
CCPP=0;
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
    
    % Warning message %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if state(4).x<0.88
        warning('Warning. The quality must be between x > 0.88 to not destroy turbine blades. You should decrease the steam pressure at the inlet of the turbine.')
        diagrams={'[]'};
    elseif isnan(state(4).x)
         warning('Warning. The quality must be between x < 1 to have a better efficiency. You should increase the steam pressure at the inlet of the turbine.')
         diagrams={'[]'};
    end
    
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
    [state, Wmov,QreHeat,turbineLossEn,turbineLossEx]=reHeating(state,state(3),0.15,pOut,eta_siT,eta_mec,eta_gen,nF,nR,CCPP);
    [state(1),Qc,condenserLossEn,condenserLossEx] = condenser(state(6));
    [state(2),Wop,pumpLossEn,pumpLossEx] = feedPump(state(1),steamPressure,eta_siP,eta_mec);
    [~,QsteamGen,~] = steamGenerator(state(2),Tmax,eta_gen);
    
    % Warning message %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if state(4).x<0.88
        warning('Warning. The quality must be between x > 0.88 to not destroy turbine blades. You should decrease the steam pressure at the inlet of the turbine.')
        diagrams={'[]'};
    elseif isnan(state(4).x)
         warning('Warning. The quality must be between x < 1 to have a better efficiency. You should increase the steam pressure at the inlet of the turbine.')
         diagrams={'[]'};
    end
    
    %TO BE MODIFIED !!!
    %determination of the work over a cycle
    Wmcy =Wmov+Wop; % note: Wmov<0, Wop>0
    Qh=QreHeat+QsteamGen;
    %Wmcy2=Qh-abs(Qc);
    %lossEn
    steamGenLossEn=abs(Qh*(1-eta_gen)/eta_gen);
    lossEn=[steamGenLossEn, condenserLossEn, turbineLossEn+pumpLossEn];
    
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
        [state,WmovTurb,QreHeat,turbineLossEn,turbineLossEx]=reHeating(state,state(3),0.18,pOut,eta_siT,eta_mec,eta_gen,nF,nR,CCPP);
    end
    [state(9+2*nR),Qc,condenserLossEn,condenserLossEx]=condenser(state(8+2*nR));
    [state,WmovAdd,WopExtractPump,extractPumpLossEn,extractPumpLossEx,turbineBleedLossEn,turbineBleedLossEx,indexDeaerator]=feedHeating(state,steamPressure,eta_siP,eta_siT,eta_mec,nF,nR,dTpinch,deaeratorON); %to do energetic and exergetic analysis
    [state(2),WopFeedPump,feedPumpLossEn,feedPumpLossEx]=feedPump(state(1),steamPressure,eta_siP,eta_mec);
    [~,QsteamGen,~]=steamGenerator(state(2),Tmax,eta_gen);
    [X]=bleedFraction(state,nF,nR,indexDeaerator);
    
    % Warning message %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if state(4).x<0.88
        warning('Warning. The quality must be between x > 0.88 to not destroy turbine blades. You should decrease the steam pressure at the inlet of the turbine.')
        diagrams={'[]'};
    elseif isnan(state(4).x)
         warning('Warning. The quality must be between x < 1 to have a better efficiency. You should increase the steam pressure at the inlet of the turbine.')
         diagrams={'[]'};
    end
    
    if indexDeaerator~=0
        %work done on the cycle
        Wmov=WmovTurb+WmovAdd*X; %turbine (note : Wmov is line vector; X is column vector)
        Wop=(1+sum(X))*(WopFeedPump+WopExtractPump(2))+(1+sum(X(1:indexDeaerator-1)))*(WopExtractPump(1));%pumps (feed pump and extracting pump)
        %determination of the work over a cycle
        Wmcy=Wmov+Wop;%note: Wmov<0, Wop>0
        Qh=QreHeat+QsteamGen;
        %Wmcy2=(1+sum(X))*Qh-abs(Qc);
        
        %lossEn
        turbineLossEn=turbineLossEn+turbineBleedLossEn*X;
        extractPumpLossEn=(1+sum(X(1:indexDeaerator-1)))*extractPumpLossEn(1)+(1+sum(X))*extractPumpLossEn(2);
        pumpLossEn=(feedPumpLossEn)*(1+sum(X))+extractPumpLossEn;
        steamGenLossEn=abs(Qh*(1-eta_gen)/eta_gen);
        
        %lossEx
        extractPumpLossEx=(1+sum(X(1:indexDeaerator-1)))*extractPumpLossEx(1)+(1+sum(X))*extractPumpLossEx(2);
        pumpLossEx=(feedPumpLossEx)*(1+sum(X))+extractPumpLossEx;
        turbineLossEx=turbineLossEx+turbineBleedLossEx*X;
    else
        %work done on the cycle
        Wmov=WmovTurb+WmovAdd*X; %turbine (note : Wmov is line vector; X is column vector)
        Wop=(1+sum(X))*(WopFeedPump+WopExtractPump(1));%pumps (feed pump and extracting pump)
        %determination of the work over a cycle
        Wmcy=Wmov+Wop;%note: Wmov<0, Wop>0
        Qh=QreHeat+QsteamGen;
        %Wmcy2=(1+sum(X))*Qh-abs(Qc)
        
        %lossEn
        turbineLossEn=turbineLossEn+turbineBleedLossEn*X;
        steamGenLossEn=abs(Qh*(1-eta_gen)/eta_gen);
        pumpLossEn=(feedPumpLossEn+extractPumpLossEn(1))*(1+sum(X));
        
        %lossEx
        turbineLossEx=turbineLossEx+turbineBleedLossEx*X;
        pumpLossEx=(feedPumpLossEx+extractPumpLossEx(1))*(1+sum(X));
    end
end

%% FLOW RATES
%determination of the mass flow rate of vapour
if nR==0 && nF==0
    mVapourSteamGen=Pe/abs(eta_mec*Wmcy);
    [eta_combex,eta_gen,mFuel,eExh,eFuel,eFlueGas,LHV]=combustion(fuel,excessAir,TflueGas+273.15,Tambiant+273.15,0.01,mVapourSteamGen*(state(3).h-state(2).h));
    er=0.04;
    mFlueGas=eta_combex*mFuel*eFuel/(eFlueGas-er);
elseif nR~=0 && nF==0
    mVapourSteamGen=Pe/abs(eta_mec*Wmcy);
    [eta_combex,eta_gen,mFuel,eExh,eFuel,eFlueGas,LHV]=combustion(fuel,excessAir,TflueGas+273.15,Tambiant+273.15,0.01,mVapourSteamGen*((state(3).h-state(2).h)+state(5).h-state(4,1).h));
    er=0.04;
    mFlueGas=eta_combex*mFuel*eFuel/(eFlueGas-er);
else
    er=0.04;
    %definition of the different flow rate
    mVapourCond=Pe/abs(eta_mec*Wmcy)
    mVapourBleed=mVapourCond*X;
    mVapourSteamGen=(1+sum(X))*mVapourCond
    if nR==0
        [eta_combex,eta_gen,mFuel,eExh,eFuel,eFlueGas,LHV]=combustion(fuel,excessAir,TflueGas+273.15,Tambiant+273.15,0.01,mVapourSteamGen*(state(3).h-state(2).h));
    else
        [eta_combex,eta_gen,mFuel,eExh,eFuel,eFlueGas,LHV]=combustion(fuel,excessAir,TflueGas+273.15,Tambiant+273.15,0.01,mVapourSteamGen*((state(3).h-state(2).h))+mVapourCond*(1+sum(X)-X(end))*(state(5).h-state(4,1).h));
    end
    mFlueGas=eta_combex*mFuel*eFuel/(eFlueGas-er);
end

%% EFFICIENCIES
%A TRIER !!! FAIRE UN TABLEAU QUI AFFICHE

if nR==0 && nF==0 %R-H cycle
    %ENERGY
    %energetic efficiency of the cycle
    eta_cyclen=abs(Wmcy)/(Qh);%NOTE : Wmcy<0
    %eta_cyclen2=(Qh-abs(Qc))/(Qh);
    %total energetic efficiency of the plant
    eta_toten=Pe/(mFuel*LHV);
    %eta_toten2=eta_gen*eta_mec*eta_cyclen
    
    %EXERGY
    eIsteamGen=exergy(state(2));
    eOsteamGen=exergy(state(3));
    %exegertic efficiency of the cycle (R-H, feed-heating)
    eta_cyclex=abs(Wmcy)/(eOsteamGen-eIsteamGen);
    %total exergetic efficiency of the plant
    eta_totex=Pe/(mFuel*eFuel);
    %efficiency related to exergy output at the stack
    eta_chimnex=(eFlueGas-eExh)/(eFlueGas-er);
    %exergetic efficiency of the heat transfer (flue gas/working fluid)
    eta_transex=mVapourSteamGen*(eOsteamGen-eIsteamGen)/(mFlueGas*(eFlueGas-eExh));
    %eta_transex2=mVapourSteamGen*(eOsteamGen-eIsteamGen)/(eta_combex*eta_chimnex*mFuel*eFuel);
    %exergetic efficiency of the steam generator
    eta_gex=mVapourSteamGen*(eOsteamGen-eIsteamGen)/(mFuel*eFuel);
    %eta_gex2=eta_transex*eta_chimnex*eta_combex;
    
elseif nR~=0 && nF ==0 %reheating only
    %ENERGY
    %energetic efficiency of the cycle
    eta_cyclen=abs(Wmcy)/(Qh);%NOTE : Wmcy<0
    %eta_cyclen2=(Qh-abs(Qc))/(Qh);
    %total energetic efficiency of the plant
    eta_toten=Pe/(mFuel*LHV)
    %eta_toten2=eta_gen*eta_mec*eta_cyclen
    
    %EXERGY
    eIsteamGen1=exergy(state(2));
    eOsteamGen1=exergy(state(3));
    eIsteamGen2=exergy(state(4,1));
    eOsteamGen2=exergy(state(5));
    %exegertic efficiency of the cycle (R-H, feed-heating)
    eta_cyclex=abs(Wmcy)/(eOsteamGen1+eOsteamGen2-(eIsteamGen1+eIsteamGen2));
    %total exergetic efficiency of the plant
    eta_totex=Pe/(mFuel*eFuel);
    %efficiency related to exergy output at the stack
    eta_chimnex=(eFlueGas-eExh)/(eFlueGas-er);
    %exergetic efficiency of the heat transfer (flue gas/working fluid)
    eta_transex=mVapourSteamGen*(eOsteamGen1+eOsteamGen2-(eIsteamGen1+eIsteamGen2))/(mFlueGas*(eFlueGas-eExh));
    %eta_transex2=mVapourSteamGen*(eOsteamGen1+eOsteamGen2-(eIsteamGen1+eIsteamGen2))/(eta_combex*eta_chimnex*mFuel*eFuel);
    %exergetic efficiency of the steam generator
    eta_gex=mVapourSteamGen*(eOsteamGen1+eOsteamGen2-(eIsteamGen1+eIsteamGen2))/(mFuel*eFuel);
    eta_gex2=eta_transex*eta_chimnex*eta_combex;
    
else %feed-heating or combining
    %ENERGY
    %energetic efficiency of the cycle
    %ILS SONT DIFFERENTS --> PAS NORMAL !
    eta_cyclen=abs(Wmcy)/((1+sum(X))*Qh);%NOTE : Wmcy<0
    eta_cyclen2=((1+sum(X))*Qh-abs(Qc))/((1+sum(X))*Qh);
    %total energetic efficiency of the plant
    eta_toten=Pe/(mFuel*LHV);
    %eta_toten2=eta_gen*eta_mec*eta_cyclen;
    
    %EXERGY
    eIsteamGen=exergy(state(2));
    eOsteamGen=exergy(state(3));
    %exegertic efficiency of the cycle (R-H, feed-heating)
    eta_cyclex=abs(Wmcy)/((1+sum(X))*(eOsteamGen-eIsteamGen));
    %total exergetic efficiency of the plant
    eta_totex=Pe/(mFuel*eFuel);
    %efficiency related to exergy output at the stack
    eta_chimnex=(eFlueGas-eExh)/(eFlueGas-er);
    %exergetic efficiency of the heat transfer (flue gas/working fluid)
    eta_transex=mVapourSteamGen*(eOsteamGen-eIsteamGen)/(mFlueGas*(eFlueGas-eExh));
    eta_transex2=mVapourSteamGen*(eOsteamGen-eIsteamGen)/(eta_combex*eta_chimnex*mFuel*eFuel);
    %exergetic efficiency of the steam generator
    eta_gex=mVapourSteamGen*(eOsteamGen-eIsteamGen)/(mFuel*eFuel);
    eta_gex2=eta_transex*eta_chimnex*eta_combex;
end
%energetic efficiency of the steam generator
eta_gen;
%mechanical efficiency of the plant
eta_mec;
%exergetic efficiency of the combustion
eta_combex;

%% Table & Diagrams %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(diagrams,'all')
    all = 1;
else
    all = 0;
end

% State table
if  any(ismember('StateTable',diagrams))||all% %% State display in table
    if nR==0 && nF==0 %Rankine-Hirn cycle
        M = (reshape(struct2array(state),6,4))';
    elseif nR~=0 && nF==0
        M = (reshape(struct2array(state),6,(stateNumber + nR)))';
    else %R-H cycle with feed-heating and/or re-heating
        M = (reshape(struct2array(state),6,(stateNumber + nR + 4*(nF-1))))';
    end
    T = array2table(M,'VariableNames',{'p','T','x','h','s','e'});
    disp(T)
    fprintf('\n')
    fprintf('Wmcy = %f kJ/kg\n\n',Wmcy)
end

% (T,s) Diagram
if any(ismember('ts',diagrams))||all
    %figure
    Ts_diagramSteam(state,eta_siP,eta_siT,nF,nR,deaeratorON,indexDeaerator)
end

% (h,s) Diagram
if any(ismember('hs',diagrams))||all
    %figure
    %hs_diagramSteam(state,eta_siP,eta_siT,nF,nR,deaeratorON,indexDeaerator)
end

%% PIE CHART
%if pieChart
%%%%%%%%%%%%%%%%%%%%%%%% RANKINE-HIRN CYCLE %%%%%%%%%%%%%%%%%%%%%%%%%%%
if nR==0 && nF==0
    er=0.04;
    
    %Energy pie chart
    if any(ismember('EnPie',diagrams))||all
        figure
        h = pie([mVapourSteamGen*lossEn,Pe]);
        hText = findobj(h,'Type','text'); % text object handles
        percentValues = get(hText,'String'); % percent values
        txt = {'Steam generator losses: ';'Condenser loss: ';'Mechanical losses: ';'Effective power: '};
        combinedtxt = strcat(txt,percentValues);
        set(hText,{'String'},combinedtxt);
        legend(txt);
    end
    
    % lossEx :
    combLossEx=mFuel*eFuel*(1-eta_combex);
    chimneyLossEx=mFlueGas*(eFlueGas-er)-mFlueGas*(eFlueGas-eExh);
    transLossEx=mFlueGas*(eFlueGas-eExh)-mVapourSteamGen*(state(3).e-state(2).e);
    steamGenLossEx=[combLossEx, chimneyLossEx, transLossEx];
    
    %Exergy pie chart
    if any(ismember('ExPie',diagrams))||all
        figure
        lossEx=mVapourSteamGen*lossEx;
        lossEx=[lossEx,steamGenLossEx];
        h = pie([lossEx,Pe]);
        hText = findobj(h,'Type','text'); % text object handles
        percentValues = get(hText,'String'); % percent values
        txt = {'Mechanical losses: ';'Irreversibilities in the turbine and pumps: ';'Condenser losses: ';'Combustion irreversibility: ';'Chimney loss: ';'Heat transfer irreversibility in the steam generator: ';'Effective power: '};
        combinedtxt = strcat(txt,percentValues);
        set(hText,{'String'},combinedtxt);
        legend(txt);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%% REHEATING ONLY %%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif nF==0 && nR ~=0
    %Energy
    if any(ismember('EnPie',diagrams))||all
        %Energy pie chart
        figure
        h = pie([mVapourSteamGen*lossEn,Pe]);
        hText = findobj(h,'Type','text'); % text object handles
        percentValues = get(hText,'String'); % percent values
        txt = {'Steam generator losses: ';'Condenser loss: ';'Mechanical losses: ';'Effective power: '};
        combinedtxt = strcat(txt,percentValues);
        set(hText,{'String'},combinedtxt);
        legend(txt);
    end
    
    %lossEx :
    combLossEx=mFuel*eFuel*(1-eta_combex);
    %combLossEx=mf*(ef-er)*(1/eta_combex-1);
    chimneyLossEx=mFlueGas*(eFlueGas-er)-mFlueGas*(eFlueGas-eExh);
    transLossEx=mFlueGas*(eFlueGas-eExh)-(mVapourSteamGen*(state(3).e-state(2).e+state(5).e-state(4,1).e));
    steamGenLossEx=[combLossEx, chimneyLossEx, transLossEx];
    
    %Exergy pie chart
    if any(ismember('ExPie',diagrams))||all
        figure
        %[mVapourSteamGen*lossEx,steamGenLossEx,Pe];
        h = pie([mVapourSteamGen*lossEx,steamGenLossEx,Pe]);
        hText = findobj(h,'Type','text'); % text object handles
        percentValues = get(hText,'String'); % percent values
        txt = {'Mechanical losses : ';'Irreversibilities in the turbine and pumps : ';'Condenser losses : ';'combex: ';'chimnex: ';'transex: ';'Effective power: '};
        %txt = {'Mechanical: ';'turbine and pumps: ';'condenser :';'combex: ';'chimnex: ';'transex: ';'Effective power: '};
        combinedtxt = strcat(txt,percentValues);
        set(hText,{'String'},combinedtxt);
        legend(txt);
    end
    
    %%%%%%%%%%%%%%%%%%%% COMBINING, FEEDHEATING ONLY %%%%%%%%%%%%%%%%%%
else
    er=0.04;
    
    %Energy
    lossEn=[mVapourSteamGen*steamGenLossEn, mVapourCond*condenserLossEn, mVapourCond*(turbineLossEn+pumpLossEn)];
    
    %Energy pie chart
    if any(ismember('EnPie',diagrams))||all
        figure
        h = pie([lossEn,Pe]);
        hText = findobj(h,'Type','text'); % text object handles
        percentValues = get(hText,'String'); % percent values
        txt = {'Steam generator losses: ';'Condenser loss: ';'Mechanical losses: ';'Effective power: '};
        combinedtxt = strcat(txt,percentValues);
        set(hText,{'String'},combinedtxt);
        legend(txt);
    end
    
    %lossEx :
    mecLossEn=(pumpLossEn+turbineLossEn)*mVapourCond;%OK
    pumpTurbLossEx=(pumpLossEx+turbineLossEx)*mVapourCond;%OK
    condenserLossEx=mVapourCond*condenserLossEx;
    if nR==0
        transLossEx=mFlueGas*(eFlueGas-eExh)-(mVapourSteamGen*(state(3).e-state(2).e));
    else
        transLossEx=mFlueGas*(eFlueGas-eExh)-(mVapourSteamGen*(state(3).e-state(2).e)+mVapourCond*(1+sum(X)-X(end))*(state(5).e-state(4,1).e));
    end
    %combLossEx=mf*(ef-er)*(1/eta_combex-1)
    combLossEx=mFuel*eFuel*(1-eta_combex);
    %combLossEx=mFuel*eFuel-mf*(ef-er)
    chimneyLossEx=mFlueGas*(eFlueGas-er)-mFlueGas*(eFlueGas-eExh);
    
    if indexDeaerator==0
        diffExergyHeatingFluid=0;
        for i=1:nF
            if i==1 && nF==1
                diffExergyHeatingFluid=diffExergyHeatingFluid+X(i)*abs(state(6+2*nR,i).e-state(4+2*nR,i).e);
            elseif i==nF && i~=1
                diffExergyHeatingFluid=diffExergyHeatingFluid+X(i)*abs(state(5+2*nR,i).e-state(4+2*nR,i).e);
            elseif i==1 && nF>1
                diffExergyHeatingFluid=diffExergyHeatingFluid+abs(sum(X)*state(6+2*nR,i).e-(X(i)*state(4+2*nR,i).e+(sum(X)-X(i))*state(6+2*nR,i+1).e));
                
            else
                diffExergyHeatingFluid=diffExergyHeatingFluid+abs((sum(X(i+1:end))+X(i))*state(5+2*nR,i).e-(X(i)*state(4+2*nR,i).e+(sum(X(i+1:end)))*state(6+2*nR,i+1).e));
            end
        end
        heatLossEx=mVapourCond*diffExergyHeatingFluid-mVapourSteamGen*abs(state(1).e-state(10+2*nR).e);
    else
        diffExergyHeatingFluid=zeros(1,3);
        for i=1:nF
            if i==nF && i>indexDeaerator%condition to be sure
                diffExergyHeatingFluid(3)=diffExergyHeatingFluid(3)+(X(i)*abs(state(5+2*nR,i).e-state(4+2*nR,i).e));
            elseif i==1 && i<indexDeaerator%%condition to be sure
                %diffExergyHeatingFluid=diffExergyHeatingFluid+(abs(sum(X(i:indexDeaerator-1)))*state(5+2*nR,i).e-(X(i)*state(4+2*nR,i).e)+sum(X(i+1:indexDeaerator-1))*state(6+2*nR,i+1).e)
                diffExergyHeatingFluid(1)=diffExergyHeatingFluid(1)+abs(sum(X(i:indexDeaerator-1))*state(6+2*nR,i).e-(X(i)*state(4+2*nR,i).e+sum(X(i+1:indexDeaerator-1))*state(6+2*nR,i+1).e));
            elseif i<indexDeaerator && i~=1
                diffExergyHeatingFluid(1)=diffExergyHeatingFluid(1)+abs(sum(X(i:indexDeaerator-1))*state(5+2*nR,i).e-(X(i)*state(4+2*nR,i).e+sum(X(i+1:indexDeaerator-1))*state(6+2*nR,i+1).e));
            elseif i==indexDeaerator
                diffExergyHeatingFluid(2)=abs(0-(X(i)*state(4+2*nR,i).e+sum(X(i+1:end))*state(6+2*nR,i+1).e));
            elseif i>indexDeaerator
                diffExergyHeatingFluid(3)=diffExergyHeatingFluid(3)+abs((sum(X(i:end)))*state(5+2*nR,i).e-(X(i)*state(4+2*nR,i).e+sum(X(i+1:end))*state(6+2*nR,i+1).e));
            else
                %do nothing
            end
        end
        heatEx=zeros(1,3);
        %             heatEx(1)=mVapourCond*(diffExergyHeatingFluid(1))-(mVapourCond*(1+sum(1:indexDeaerator-1))*abs(state(11+2*nR,indexDeaerator).e-state(10+2*nR).e));
        %             heatEx(2)=mVapourCond*(diffExergyHeatingFluid(2))-abs(mVapourSteamGen*state(5+2*nR,indexDeaerator).e-mVapourCond*(1+sum(X(1:indexDeaerator-1)))*(state(11+2*nR,indexDeaerator).e));
        %             heatEx(3)=mVapourCond*(diffExergyHeatingFluid(3))-mVapourSteamGen*abs(state(1).e-state(11+2*nR,indexDeaerator+1).e);
        heatEx(1)=mVapourCond*(diffExergyHeatingFluid(1));
        heatEx(2)=mVapourCond*(diffExergyHeatingFluid(2));
        heatEx(3)=mVapourCond*(diffExergyHeatingFluid(3));
        heatLossEx=sum(heatEx)-mVapourCond*((1+sum(X))*abs(state(1).e)-(1+sum(1:indexDeaerator-1))*state(10+2*nR,1).e);
    end
    %lossEx in the steam generator : combex, chimnex, transex
    steamGenLossEx=[combLossEx, chimneyLossEx, transLossEx];
    %lossEx total:
    lossEx=[mecLossEn,pumpTurbLossEx,condenserLossEx,heatLossEx,steamGenLossEx];
    
    %Exergy pie chart
    if any(ismember('ExPie',diagrams))||all
        figure
        h = pie([lossEx,Pe]);
        hText = findobj(h,'Type','text'); % text object handles
        percentValues = get(hText,'String'); % percent values
        txt = {'Mechanical losses: ';'Irreversibilities in the turbine and pumps: ';'Condenser loss: ';'Heat transfer irreversibilities in the feed-water heater: ';'Combustion irreversibility: ';'Chimney loss: ';'Heat transfer irreversibility in the steam generator: ';'Effective power: '};
        %txt = {'Mechanical: ';'turbine and pumps: ';'condenser :';'combex: ';'chimnex: ';'transex: ';'Effective power: '};
        combinedtxt = strcat(txt,percentValues);
        set(hText,{'String'},combinedtxt);
        legend(txt);
    end
end
end