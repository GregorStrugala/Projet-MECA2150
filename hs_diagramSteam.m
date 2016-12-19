function [ ] = hs_diagramSteam(state,eta_siP,eta_siT,nF,nR,deaeratorON,indexDeaerator)
%function
T=0.01:0.1:373.945;
%Preallocation
sv_t=zeros(1,length(T));
sl_t=zeros(1,length(T));
psat=zeros(1,length(T));
h_psl=zeros(1,length(T));
h_psv=zeros(1,length(T));

for index=1:length(T)
    sv_t(index)=XSteam('sv_t',T(index));
    sl_t(index)=XSteam('sl_t',T(index));
    psat(index)=XSteam('psat_t',T(index));
    h_psl(index)=XSteam('h_ps',psat(index),sl_t(index));
    h_psv(index)=XSteam('h_ps',psat(index),sv_t(index));
end

figure;
% diagram h-s
%plot(sl_t,h_psl,sv_t,h_psv)
plot([sl_t fliplr(sv_t)], [h_psl fliplr(h_psv)],'Color','g','LineStyle','-','LineWidth',1.5)%no hole
%% %%%%%%%%%%%%%%%%%%%%%%%%%% RANKINE-HIRN CYCLE %%%%%%%%%%%%%%%%%%%%%%%%%%%
if nF == 0 && nR == 0; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % PLOT : compression in the feed pump
    %CODE A VERIFIER !!!!! OK VALABLE QUE LORSQUE LE TITRE EST DEFINI CAD
    %LORSQUE L ETAT 4 EST DANS LA CLOCHE --> a modifier
    hold on
    plot(state(1).s,state(1).h,'o')
    text(state(1).s,state(1).h,'1')
    
    [~,sComp,hComp]=CompressionExpansionPlot(state(1),state(2),eta_siP,1,0);
    hold on
    plot(sComp,hComp,'Color','r','LineStyle','-','LineWidth',1.5)
    
    
    % PLOT : vaporization in the steam generator
    
    hold on
    plot(state(2).s,state(2).h,'o')
    text(state(2).s,state(2).h,'2')
    
    [~,sVap1,hVap1]=vaporizationCondensationPlot(state(2),state(3));
    hold on
    plot(sVap1,hVap1,'Color','r','LineStyle','-','LineWidth',1.5)
    
    % PLOT : Expansion in the turbine
    hold on
    plot(state(3).s,state(3).h,'o')
    text(state(3).s,state(3).h,'3')
    
    [~,s_turb,h_turb]=CompressionExpansionPlot(state(3),state(4),eta_siT,0,1);
    hold on
    plot(s_turb,h_turb,'Color','r','LineStyle','-','LineWidth',1.5)
    
    % PLOT : condensation in the condenser
    hold on
    plot(state(4).s,state(4).h,'o')
    text(state(4).s,state(4).h,'4')
    if isnan(state(4).x)
        
        %To be done
    else  %case without feedHeating and reHeating
        plot([state(4).s,state(1).s],[state(4).h,state(1).h],'Color','r','LineStyle','-','LineWidth',1.5)
    end
    
    %%    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FEEDHEATING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif nF > 0 %&& reHeat == 0 && nR == 0%%%%%%%%%%%%%%%%%%%
    
    %% PLOT : compression in the feed pump
    %CODE A VERIFIER !!!!! OK VALABLE QUE LORSQUE LE TITRE EST DEFINI CAD
    %LORSQUE L ETAT 4 EST DANS LA CLOCHE --> a modifier
    hold on
    plot(state(1).s,state(1).h,'o')
    text(state(1).s,state(1).h,'1')    
    [~,sComp,hComp]=CompressionExpansionPlot(state(1),state(2),eta_siP,1,0);
    hold on
    plot(sComp,hComp,'Color','r','LineStyle','-','LineWidth',1.5)
    
    
    % PLOT : vaporization in the steam generator
    hold on
    plot(state(2).s,state(2).h,'o')
    text(state(2).s,state(2).h,'2')
    
    [~,sVap1,hVap1]=vaporizationCondensationPlot(state(2),state(3));
    hold on
    plot(sVap1,hVap1,'Color','r','LineStyle','-','LineWidth',1.5)
    % PLOT : Expansion in the turbine
    hold on
    plot(state(3).s,state(3).h,'o')
    text(state(3).s,state(3).h,'3')
    
    if nR == 0
        hold on
        plot(state(8).s,state(8).h,'o')
        text(state(8).s,state(8).h,'8')
        [~,s_turb,h_turb]=CompressionExpansionPlot(state(3),state(8),eta_siT,0,1);
        hold on
        plot(s_turb,h_turb,'Color','r','LineStyle','-','LineWidth',1.5)
    else
        hold on
        plot(state(4,1).s,state(4,1).h,'o')
        text(state(4,1).s,state(4,1).h,'4.1')
        [~,s_turb1,h_turb1]=CompressionExpansionPlot(state(3),state(4,2),eta_siT,0,1);
        hold on
        plot(s_turb1,h_turb1,'Color','m','LineStyle','-.','LineWidth',1.5)
        
        hold on
        plot(state(4,2).s,state(4,2).h,'o')
        text(state(4,2).s,state(4,2).h,'4.2')
        [~,s_turb,h_turb]=CompressionExpansionPlot(state(3),state(4,1),eta_siT,0,1);
        hold on
        plot(s_turb,h_turb,'Color','r','LineStyle','-','LineWidth',1.5)
        
        %         [Tvap2,sVap2,~]=vaporizationCondensationPlot(state(2),state(5));
        %         hold on
        %         plot(sVap2,Tvap2,'Color','m','LineStyle','-.','LineWidth',1.5)
        
        hold on
        plot(state(5).s,state(5).h,'o')
        text(state(5).s,state(5).h,'5')
        T1=state(4,1).T:abs(state(5).T-state(4,1).T)*0.01:state(5).T;
        sR=zeros(1,length(T1));
        hR=zeros(1,length(T1));
        for i=1:length(T1)
            sR(i)=XSteam('s_pt',state(5).p,T1(i));
            hR(i)=XSteam('h_pt',state(5).p,T1(i)); 
        end
        
        outTurbine = 8+2*nR;
        hold on
        plot(state(8+2*nR).s,state(8+2*nR).h,'o')
        text(state(8+2*nR).s,state(8+2*nR).h,num2str(outTurbine))
        
        hold on
        plot(sR,hR,'Color','r','LineStyle','-','LineWidth',1.5)
        [~,s_turb,h_turb]=CompressionExpansionPlot(state(5),state(8+2*nR),eta_siT,0,1);
        hold on
        plot(s_turb,h_turb,'Color','r','LineStyle','-','LineWidth',1.5)
        
        
    end
    % PLOT : condensation in the condenser
    %     hold on
    %
    %     plot(state(8+2*nR).s,state(8+2*nR).T,'o')
    %     text(state(8+2*nR).s,state(8+2*nR).T,'8')
    hold on
    outCondenser = 9+2*nR;
    plot(state(9+2*nR).s,state(9+2*nR).h,'o')
    text(state(9+2*nR).s,state(9+2*nR).h,num2str(outCondenser))
    plot([state(8+2*nR).s,state(9+2*nR).s],[state(8+2*nR).h,state(9+2*nR).h],'Color','r','LineStyle','-','LineWidth',1.5)
    
    % PLOT : reheating in the different heater
    if deaeratorON && indexDeaerator>0
        %reheat in the heaters before the deaerator
        hold on
        outDeaerator=5+2*nR;
        plot(state(5+2*nR,indexDeaerator).s,state(5+2*nR,indexDeaerator).h,'*');
        text(state(5+2*nR,indexDeaerator).s,state(5+2*nR,indexDeaerator).h,num2str(outDeaerator));
        
        T1=state(10+2*nR).T:abs(state(5+2*nR,indexDeaerator).T-state(10+2*nR).T)*0.01:state(5+2*nR,indexDeaerator).T;
        sBeforeDeaerator=zeros(1,length(T1));
        hBeforeDeaerator=zeros(1,length(T1));
        for i=1:length(T1)
            if i==length(T1)
                sBeforeDeaerator(i)=state(5+2*nR,indexDeaerator).s;
                hBeforeDeaerator(i)=state(5+2*nR,indexDeaerator).h;
            elseif i==1
                sBeforeDeaerator(i)=state(10+2*nR).s;
                hBeforeDeaerator(i)=state(10+2*nR).h;
            else
                sBeforeDeaerator(i)=XSteam('s_pt',state(5+2*nR,indexDeaerator).p,T1(i));
                hBeforeDeaerator(i)=XSteam('h_pt',state(5+2*nR,indexDeaerator).p,T1(i));
            end
        end
        hold on
        plot(sBeforeDeaerator,hBeforeDeaerator,'Color','r','LineStyle','-','LineWidth',1.5)
        
        %compression in the extracting pump
        hold on
        outExtractingPump=(11+2*nR)*10+indexDeaerator;
        plot(state(11+2*nR,indexDeaerator+1).s,state(11+2*nR,indexDeaerator+1).h,'o');
        text(state(11+2*nR,indexDeaerator+1).s,state(11+2*nR,indexDeaerator+1).h,num2str(outExtractingPump));
        [~,sDeaePump,hDeaePump]=CompressionExpansionPlot(state(5+2*nR,indexDeaerator),state(11+2*nR,indexDeaerator+1),eta_siP,1,0);
        hold on
        plot(sDeaePump,hDeaePump,'Color','r','LineStyle','-','LineWidth',1.5)
        
        %reheat in the heater after the deaerator until the inlet of the
        %pump
        T2=state(11+2*nR,indexDeaerator+1).T:abs(state(1).T-state(11+2*nR,indexDeaerator+1).T)*0.001:state(1).T;
        sAfterDeaerator=zeros(1,length(T2));
        hAfterDeaerator=zeros(1,length(T2));
        for i=1:length(T2)
            if i==length(T2)
                sAfterDeaerator(i)=state(1).s;
                hAfterDeaerator(i)=state(1).h;
            end
            sAfterDeaerator(i)=XSteam('s_pt',state(1).p,T2(i));
            hAfterDeaerator(i)=XSteam('h_pt',state(1).p,T2(i));
        end
        hold on
        plot(sAfterDeaerator,hAfterDeaerator,'Color','r','LineStyle','-','LineWidth',1.5)
    else
        T1=state(10+2*nR).T:abs(state(1).T-state(10+2*nR).T)*0.01:state(1).T;
        sR=zeros(1,length(T1));
        hR=zeros(1,length(T1));
        for i=1:length(T1)
            sR(i)=XSteam('s_pt',state(1).p,T1(i));
            hR(i)=XSteam('h_pt',state(1).p,T1(i));
        end
        hold on
        plot(sR,hR,'Color','r','LineStyle','-','LineWidth',1.5)
    end
    
    for index=1:nF
        % PLOT : bleed steam in the turbine, condensation in the heater and the subcooler
        hold on
        feedHeat=zeros(1,nF);
        feedHeat(index)=(4+2*nR)*10+index; %ok for nF<10
        plot(state(4+2*nR,index).s,state(4+2*nR,index).h,'o')
        text(state(4+2*nR,index).s,state(4+2*nR,index).h,num2str(feedHeat(index)))
        hold on
        plot(state(5+2*nR,index).s,state(5+2*nR,index).h,'o')
        hold on
        if index == 1
            [~,sCond,hCond]=vaporizationCondensationPlot(state(6+2*nR,index),state(4+2*nR,index));
        else
            [~,sCond,hCond]=vaporizationCondensationPlot(state(5+2*nR,index),state(4+2*nR,index));
        end
        hold on
        plot(sCond,hCond,'Color','b','LineStyle','--','LineWidth',1.5)
        
        % PLOT : isenthalpic expansion in the valve
        hold on
        outSubcooler=7+2*nR;
        plot(state(7+2*nR).s,state(7+2*nR).h,'o')
        text(state(7+2*nR).s,state(7+2*nR).h,num2str(outSubcooler))
        hold on
         hold on
        outValve=(6+2*nR)*10+index;
        %state(6+2*nR,index).h
        state(6+2*nR,index).s
        plot(state(6+2*nR,index).s,state(6+2*nR,index).h,'o')
        text(state(6+2*nR,index).s,state(6+2*nR,index).h,num2str(outValve))
        hold on
        outHeater=(5+2*nR)*10+index;
        plot(state(5+2*nR,index).s,state(5+2*nR,index).h,'o')
        text(state(5+2*nR,index).s,state(5+2*nR,index).h,num2str(outHeater),'Position',[state(5+2*nR,index).s,state(5+2*nR,index).h])
        if index == 1
            [~,sExp,hExp] = isenthalpicExpansion(state(7+2*nR,index),state(6+2*nR,index));
            hold on
            plot(sExp,hExp,'Color','b','LineStyle','--','LineWidth',1.5)
        elseif index==indexDeaerator
            %...do nothing
        else
            [~,sExp,hExp] = isenthalpicExpansion(state(6+2*nR,index),state(5+2*nR,index));
            hold on
            plot(sExp,hExp,'Color','b','LineStyle','--','LineWidth',1.5)
        end
        
        % PLOT : compression in the extracting pump
        hold on
        outExtractPump=10+2*nR;
        plot(state(10+2*nR).s,state(10+2*nR).h,'o')
        text(state(10+2*nR).s,state(10+2*nR).h,num2str(outExtractPump),'Position',[state(10+2*nR).s,state(10+2*nR).h])
        
        [~,sComp2,hComp2]=CompressionExpansionPlot(state(9+2*nR),state(10+2*nR),eta_siP,1,0);
        hold on
        plot(sComp2,hComp2,'Color','r','LineStyle','-','LineWidth',1.5)
    end
    %==============================================================================
    %FOR TEST
    %     hold on
    %     plot(state(1).s,state(1).T,'o')
    %     text(state(1).s,state(1).T,'1')
    %     hold on
    %     plot(state(2).s,state(2).T,'o')
    %     text(state(2).s,state(2).T,'2')
    %     hold on
    %     plot(state(3).s,state(3).T,'o')
    %     text(state(3).s,state(3).T,'3')
    %     hold on
    %     plot(state(4,1).s,state(4,1).T,'o')
    %     text(state(4,1).s,state(4,1).T,'4.1')
    %     hold on
    %     plot(state(4,2).s,state(4,2).T,'o')
    %     text(state(4,2).s,state(4,2).T,'4.2')
    %     hold on
    %     plot(state(4,3).s,state(4,3).T,'o')
    %     text(state(4,3).s,state(4,3).T,'4.3')
    %     hold on
    %     plot(state(4,4).s,state(4,4).T,'o')
    %     text(state(4,4).s,state(4,4).T,'4.4')
    %     hold on
    %     plot(state(5,1).s,state(5,1).T,'o')
    %     text(state(5,1).s,state(5,1).T,'5.1')
    %     hold on
    %     plot(state(5,2).s,state(5,2).T,'o')
    %     text(state(5,2).s,state(5,2).T,'5.2')
    %     hold on
    %     plot(state(5,3).s,state(5,3).T,'o')
    %     text(state(5,3).s,state(5,3).T,'5.3')
    %     hold on
    %     plot(state(5,4).s,state(5,4).T,'o')
    %     text(state(5,4).s,state(5,4).T,'5.4')
    %     hold on
    %     plot(state(6,1).s,state(6,1).T,'o')
    %     text(state(6,1).s,state(6,1).T,'6.1')
    %     hold on
    %     plot(state(6,2).s,state(6,2).T,'o')
    %     text(state(6,2).s,state(6,2).T,'6.2')
    %     hold on
    %     plot(state(6,3).s,state(6,3).T,'o')
    %     text(state(6,3).s,state(6,3).T,'6.3')
    %     hold on
    %     plot(state(6,4).s,state(6,4).T,'o')
    %     text(state(6,4).s,state(6,4).T,'6.4')
    %     hold on
    %     plot(state(7).s,state(7).T,'o')
    %     text(state(7).s,state(7).T,'7')
    %     hold on
    %     plot(state(8).s,state(8).T,'o')
    %     text(state(8).s,state(8).T,'8')
    %      hold on
    %     plot(state(9).s,state(9).T,'o')
    %     text(state(9).s,state(9).T,'9')
    %      hold on
    %     plot(state(10).s,state(10).T,'o')
    %     text(state(10).s,state(10).T,'10')
    %     hold on
    %     plot(state(11,1).s,state(11,1).T,'o')
    %     text(state(11,1).s,state(11,1).T,'11.1')
    %     hold on
    %     plot(state(11,2).s,state(11,2).T,'o')
    %     text(state(11,2).s,state(11,2).T,'11.2')
    %     hold on
    %     plot(state(11,3).s,state(11,3).T,'o')
    %     text(state(11,3).s,state(11,3).T,'11.3')
    %     hold on
    %     plot(state(11,4).s,state(11,4).T,'*')
    %     text(state(11,4).s,state(11,4).T,'11.4')
    
    %%    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% REHEATING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif nR > 0 && nF == 0 %%%%%%%%%%%%%%%%%%%
    % PLOT : compression in the feed pump
    %CODE A VERIFIER !!!!! OK VALABLE QUE LORSQUE LE TITRE EST DEFINI CAD
    %LORSQUE L ETAT 4 EST DANS LA CLOCHE --> a modifier
    hold on
    plot(state(1).s,state(1).h,'o')
    text(state(1).s,state(1).h,'1')
    
    [~,sComp,hComp]=CompressionExpansionPlot(state(1),state(2),eta_siP,1,0);
    hold on
    plot(sComp,hComp,'Color','r','LineStyle','-','LineWidth',1.5)
    
    % PLOT : vaporization in the steam generator
    hold on
    plot(state(2).s,state(2).h,'o')
    text(state(2).s,state(2).h,'2')
    
    [~,sVap1,hVap1]=vaporizationCondensationPlot(state(2),state(3));
    hold on
    plot(sVap1,hVap1,'Color','r','LineStyle','-','LineWidth',1.5)
    [~,sVap2,hVap2]=vaporizationCondensationPlot(state(2),state(5));
    hold on
    plot(sVap2,hVap2,'Color','m','LineStyle','-.','LineWidth',1.5)
    
    % PLOT : Expansion in the turbine
    hold on
    plot(state(3).s,state(3).h,'o')
    text(state(3).s,state(3).h,'3')
    hold on
    plot(state(4,1).s,state(4,1).h,'o')
    text(state(4,1).s,state(4,1).h,'4.1')
    hold on
    plot(state(4,2).s,state(4,2).h,'o')
    text(state(4,2).s,state(4,2).h,'4.2')
    hold on
    plot(state(5).s,state(5).h,'o')
    text(state(5).s,state(5).h,'5')
    
    [~,s_turb1,h_turb1]=CompressionExpansionPlot(state(3),state(4,2),eta_siT,0,1);
    hold on
    plot(s_turb1,h_turb1,'Color','b','LineStyle','--','LineWidth',1.5)
    
    [~,s_turb2,h_turb2]=CompressionExpansionPlot(state(3),state(4,1),eta_siT,0,1);
    hold on
    plot(s_turb2,h_turb2,'Color','r','LineStyle','-','LineWidth',1.5)
    
    [~,s_turb3,h_turb3]=CompressionExpansionPlot(state(5),state(6),eta_siT,0,1);
    hold on
    plot(s_turb3,h_turb3,'Color','r','LineStyle','-','LineWidth',1.5)
    
    T1=state(4,1).T:abs(state(5).T-state(4,1).T)*0.01:state(5).T;
    sR=zeros(1,length(T1));
    hR=zeros(1,length(T1));
    for i=1:length(T1)
        sR(i)=XSteam('s_pt',state(5).p,T1(i));
        hR(i)=XSteam('h_pt',state(5).p,T1(i));
    end
    hold on
    plot(sR,hR,'Color','r','LineStyle','-','LineWidth',1.5)
    
    % PLOT : condensation in the condenser
    
    hold on
    plot(state(6).s,state(6).h,'o')
    text(state(6).s,state(6).h,'6')
    if isnan(state(6).x)
        %To be done
    else  %case without feedHeating and reHeating
        plot([state(6).s,state(1).s],[state(6).h,state(1).h],'Color','r','LineStyle','-','LineWidth',1.5)
    end
    hold on
    plot(state(3).s,state(3).h,'o')
    text(state(3).s,state(3).h,'3')
    hold on
    plot(state(4,1).s,state(4,1).h,'o')
    text(state(4,1).s,state(4,1).h,'4.1')
    hold on
    plot(state(4,2).s,state(4,2).h,'o')
    text(state(4,2).s,state(4,2).h,'4.2')
    
    hold on
    plot(state(5).s,state(5).h,'o')
    text(state(5).s,state(5).h,'5')
    hold on
    plot(state(6).s,state(6).h,'o')
    text(state(6).s,state(6).h,'6')
    hold on
    plot(state(1).s,state(1).h,'o')
    text(state(1).s,state(1).h,'1')
    hold on
    plot(state(2).s,state(2).h,'o')
    text(state(2).s,state(2).h,'2')

end
end