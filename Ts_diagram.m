function [ ] = Ts_diagram(state, eta_siP, eta_siT, nF, nR)
%Note : changer les noms des variables, peu coherent
%mettre commentaires
%Faire un beau graphe !
%global state

Tvap=0.1:0.1:373.9459;

%Preallocation
sv_t=zeros(1,length(Tvap));
sl_t=zeros(1,length(Tvap));
psat=zeros(1,length(Tvap));
h_psl=zeros(1,length(Tvap));
h_psv=zeros(1,length(Tvap));

for index=1:length(Tvap)
    sv_t(index)=XSteam('sv_t',Tvap(index));
    sl_t(index)=XSteam('sl_t',Tvap(index));
    psat(index)=XSteam('psat_t',Tvap(index));
    h_psl(index)=XSteam('h_ps',psat(index),sl_t(index));
    h_psv(index)=XSteam('h_ps',psat(index),sv_t(index));
end
figure;
% diagram T-s
%plot(sl_t,T,sv_t,T)
plot([sl_t fliplr(sv_t)], [Tvap fliplr(Tvap)],'Color','g','LineStyle','-','LineWidth',1.5)% no hole



%%%%%%%%%%%%%%%%%%%%%%%%%%%% RANKINE-HIRN CYCLE %%%%%%%%%%%%%%%%%%%%%%%%%%%
if nF == 0 && nR == 0; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% PLOT : compression in the feed pump
    %CODE A VERIFIER !!!!! OK VALABLE QUE LORSQUE LE TITRE EST DEFINI CAD
    %LORSQUE L ETAT 4 EST DANS LA CLOCHE --> a modifier
    hold on
    plot(state(1).s,state(1).T,'o')
    text(state(1).s,state(1).T,'1')
    
    [Tcomp,sComp,~]=CompressionExpansionPlot(state(1),state(2),eta_siP,1,0);
    hold on
    plot(sComp,Tcomp,'Color','r','LineStyle','-','LineWidth',1.5)
    
    
    %% PLOT : vaporization in the steam generator
    
    hold on
    plot(state(2).s,state(2).T,'o')
    text(state(2).s,state(2).T,'2')
    
    [Tvap,sVap1,~]=vaporizationCondensationPlot(state(2),state(3));
    hold on
    plot(sVap1,Tvap,'Color','r','LineStyle','-','LineWidth',1.5)
    
    %% PLOT : Expansion in the turbine
    hold on
    plot(state(3).s,state(3).T,'o')
    text(state(3).s,state(3).T,'3')
    
    [T_turb,s_turb,~]=CompressionExpansionPlot(state(3),state(4),eta_siT,0,1);
    hold on
    plot(s_turb,T_turb,'Color','r','LineStyle','-','LineWidth',1.5)
    
    %% PLOT : condensation in the condenser
    hold on
    plot(state(4).s,state(4).T,'o')
    text(state(4).s,state(4).T,'4')
    if isnan(state(4).x)
        
        %To be done
    else  %case without feedHeating and reHeating
        plot([state(4).s,state(1).s],[state(4).T,state(1).T],'Color','r','LineStyle','-','LineWidth',1.5)
    end
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FEEDHEATING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif nF > 0 %&& reHeat == 0 && nR == 0%%%%%%%%%%%%%%%%%%%
    
    %     %% PLOT : compression in the feed pump
    %     %CODE A VERIFIER !!!!! OK VALABLE QUE LORSQUE LE TITRE EST DEFINI CAD
    %     %LORSQUE L ETAT 4 EST DANS LA CLOCHE --> a modifier
    hold on
    plot(state(1).s,state(1).T,'o')
    text(state(1).s,state(1).T,'1')
    
    [Tcomp,sComp,~]=CompressionExpansionPlot(state(1),state(2),eta_siP,1,0);
    hold on
    plot(sComp,Tcomp,'Color','r','LineStyle','-','LineWidth',1.5)
    
    
    %% PLOT : vaporization in the steam generator
    
    hold on
    plot(state(2).s,state(2).T,'o')
    text(state(2).s,state(2).T,'2')
    
    [Tvap,sVap1,~]=vaporizationCondensationPlot(state(2),state(3));
    hold on
    plot(sVap1,Tvap,'Color','r','LineStyle','-','LineWidth',1.5)
    %% PLOT : Expansion in the turbine
    hold on
    plot(state(3).s,state(3).T,'o')
    text(state(3).s,state(3).T,'3')
    if nR == 0
        
        [T_turb,s_turb,~]=CompressionExpansionPlot(state(3),state(8),eta_siT,0,1);
        hold on
        plot(s_turb,T_turb,'Color','r','LineStyle','-','LineWidth',1.5)
    else
        [T_turb1,s_turb1,~]=CompressionExpansionPlot(state(3),state(4,2),eta_siT,0,1);
        hold on
        plot(s_turb1,T_turb1,'Color','m','LineStyle','-.','LineWidth',1.5)
        
        [T_turb,s_turb,~]=CompressionExpansionPlot(state(3),state(4,1),eta_siT,0,1);
        hold on
        plot(s_turb,T_turb,'Color','r','LineStyle','-','LineWidth',1.5)
        
%         [Tvap2,sVap2,~]=vaporizationCondensationPlot(state(2),state(5));
%         hold on
%         plot(sVap2,Tvap2,'Color','m','LineStyle','-.','LineWidth',1.5)
        
        T=state(4,1).T:abs(state(5).T-state(4,1).T)*0.01:state(5).T;
        sR=zeros(1,length(T));
        for i=1:length(T)
            sR(i)=XSteam('s_pt',state(5).p,T(i));
        end
        hold on
        plot(sR,T,'Color','r','LineStyle','-','LineWidth',1.5)
        [T_turb,s_turb,~]=CompressionExpansionPlot(state(5),state(8+2*nR),eta_siT,0,1);
        hold on
        plot(s_turb,T_turb,'Color','r','LineStyle','-','LineWidth',1.5)
        
        
    end
    %% PLOT : condensation in the condenser
    hold on
    
    plot(state(8+2*nR).s,state(8+2*nR).T,'o')
    text(state(8+2*nR).s,state(8+2*nR).T,'8')
    hold on
    plot(state(9+2*nR).s,state(9+2*nR).T,'o')
    text(state(9+2*nR).s,state(9+2*nR).T,'9')
    plot([state(8+2*nR).s,state(9+2*nR).s],[state(8+2*nR).T,state(9+2*nR).T],'Color','r','LineStyle','-','LineWidth',1.5)
    %% PLOT : reheating in the different heater
    
            T=state(10+2*nR).T:abs(state(1).T-state(10+2*nR).T)*0.01:state(1).T;
            sR=zeros(1,length(T));
            for i=1:length(T)
                sR(i)=XSteam('s_pt',state(1).p,T(i));
            end
            hold on
            plot(sR,T,'Color','r','LineStyle','-','LineWidth',1.5)
        for index=1:nF
    
            %% PLOT : bleed steam in the turbine, condensation in the heater and the subcooler
            hold on
            plot(state(4+2*nR,index).s,state(4+2*nR,index).T,'o')
            text(state(4+2*nR,index).s,state(4+2*nR,index).T,'4')
            hold on
            plot(state(5+2*nR,index).s,state(5+2*nR,index).T,'o')
            hold on
            if index == 1
                [Tcond,sCond,~]=vaporizationCondensationPlot(state(6+2*nR,index),state(4+2*nR,index));
            else
                [Tcond,sCond,~]=vaporizationCondensationPlot(state(5+2*nR,index),state(4+2*nR,index));
            end
            hold on
            plot(sCond,Tcond,'Color','b','LineStyle','--','LineWidth',1.5)
    
            %% PLOT : isenthalpic expansion in the valve
            hold on
            plot(state(7+2*nR).s,state(7+2*nR).T,'o')
            text(state(7+2*nR).s,state(7+2*nR).T,'7')
            hold on
            plot(state(6+2*nR,index).s,state(6+2*nR,index).T,'o')
            text(state(6+2*nR,index).s,state(6+2*nR,index).T,'6')
            hold on
            plot(state(5+2*nR,index).s,state(5+2*nR,index).T,'o')
            text(state(5+2*nR,index).s,state(5+2*nR,index).T,'5','Position',[state(5+2*nR,index).s,state(5+2*nR,index).T])
            if index == 1
                [Texp,sExp,~] = isenthalpicExpansion(state(7+2*nR,index),state(6+2*nR,index));
                hold on
                plot(sExp,Texp,'Color','b','LineStyle','--','LineWidth',1.5)
            else
                [Texp,sExp,~] = isenthalpicExpansion(state(6+2*nR,index),state(5+2*nR,index));
                hold on
                plot(sExp,Texp,'Color','b','LineStyle','--','LineWidth',1.5)
            end
    
            %% PLOT : compression in the extracting pump
            hold on
            plot(state(10+2*nR).s,state(10+2*nR).T,'o')
            text(state(10+2*nR).s,state(10+2*nR).T,'10','Position',[state(10+2*nR).s,state(10+2*nR).T])
    
            [Tcomp2,sComp2,~]=CompressionExpansionPlot(state(9+2*nR),state(10+2*nR),0.8,1,0);
            hold on
            plot(sComp2,Tcomp2,'Color','r','LineStyle','-','LineWidth',1.5)
         end
    %
    %     hold on
    %     plot(state(3).s,state(3).T,'o')
    %     text(state(3).s,state(3).T,'3')
    %     hold on
    %     for i=1:nF
    %         plot(state(4,i).s,state(4,i).T,'o')
    %         text(state(4,i).s,state(4,i).T,'4.i')
    %         plot(state(5,i).s,state(5,i).T,'o')
    %         text(state(5,i).s,state(5,i).T,'5.i')
    %         plot(state(6,i).s,state(6,i).T,'o')
    %         text(state(6,i).s,state(6,i).T,'6.i')
    %     end
    %     for i=1:nF
    %         hold on
    %         plot(state(11,i).s,state(11,i).T,'*')
    %         text(state(11,i).s,state(11,i).T,'11')
    %     end
    hold on
    plot(state(3).s,state(3).T,'o')
    text(state(3).s,state(3).T,'3')
    hold on
    plot(state(4,1).s,state(4,1).T,'o')
    text(state(4,1).s,state(4,1).T,'4.1')
    hold on
    plot(state(4,2).s,state(4,2).T,'o')
    text(state(4,2).s,state(4,2).T,'4.2')
    hold on
    plot(state(5).s,state(5).T,'o')
    text(state(5).s,state(5).T,'5')
    hold on
    plot(state(8+2*nR).s,state(8+2*nR).T,'o')
    text(state(8+2*nR).s,state(8+2*nR).T,'10')
    for i=1:nF
        plot(state(4+2*nR,i).s,state(4+2*nR,i).T,'o')
        text(state(4+2*nR,i).s,state(4+2*nR,i).T,'6.i')
        plot(state(5+2*nR,i).s,state(5+2*nR,i).T,'o')
        text(state(5+2*nR,i).s,state(5+2*nR,i).T,'7.i')
        plot(state(6+2*nR,i).s,state(6+2*nR,i).T,'o')
        text(state(6+2*nR,i).s,state(6+2*nR,i).T,'8.i')
        plot(state(11+2*nR,i).s,state(11+2*nR,i).T,'*')
        text(state(11+2*nR,i).s,state(11+2*nR,i).T,'13.i')
        
    end
    
    plot(state(7+2*nR).s,state(7+2*nR).T,'o')
    text(state(7+2*nR).s,state(7+2*nR).T,'9')
    plot(state(8+2*nR).s,state(8+2*nR).T,'o')
    text(state(8+2*nR).s,state(8+2*nR).T,'10')
    plot(state(9+2*nR).s,state(9+2*nR).T,'o')
    text(state(9+2*nR).s,state(9+2*nR).T,'11')
    plot(state(8+2*nR).s,state(8+2*nR).T,'o')
    text(state(8+2*nR).s,state(8+2*nR).T,'10')
    plot(state(1).s,state(1).T,'o')
    text(state(1).s,state(1).T,'1')
    plot(state(2).s,state(2).T,'o')
    text(state(2).s,state(2).T,'2')
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% REHEATING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif nR > 0 && nF == 0 %%%%%%%%%%%%%%%%%%%
    %% PLOT : compression in the feed pump
    %CODE A VERIFIER !!!!! OK VALABLE QUE LORSQUE LE TITRE EST DEFINI CAD
    %LORSQUE L ETAT 4 EST DANS LA CLOCHE --> a modifier
    hold on
    plot(state(1).s,state(1).T,'o')
    text(state(1).s,state(1).T,'1')
    
    [Tcomp,sComp,~]=CompressionExpansionPlot(state(1),state(2),eta_siP,1,0);
    hold on
    plot(sComp,Tcomp,'Color','r','LineStyle','-','LineWidth',1.5)
    
    %% PLOT : vaporization in the steam generator
    hold on
    plot(state(2).s,state(2).T,'o')
    text(state(2).s,state(2).T,'2')
    
    [Tvap1,sVap1,~]=vaporizationCondensationPlot(state(2),state(3));
    hold on
    plot(sVap1,Tvap1,'Color','r','LineStyle','-','LineWidth',1.5)
    [Tvap2,sVap2,~]=vaporizationCondensationPlot(state(2),state(5));
    hold on
    plot(sVap2,Tvap2,'Color','m','LineStyle','-.','LineWidth',1.5)
    
    %% PLOT : Expansion in the turbine
    hold on
    plot(state(3).s,state(3).T,'o')
    text(state(3).s,state(3).T,'3')
    hold on
    plot(state(4,1).s,state(4,1).T,'o')
    text(state(4,1).s,state(4,1).T,'4.1')
    hold on
    plot(state(4,2).s,state(4,2).T,'o')
    text(state(4,2).s,state(4,2).T,'4.2')
    hold on
    plot(state(5).s,state(5).T,'o')
    text(state(5).s,state(5).T,'5')
    
    [T_turb1,s_turb1,~]=CompressionExpansionPlot(state(3),state(4,2),eta_siT,0,1);
    hold on
    plot(s_turb1,T_turb1,'Color','b','LineStyle','--','LineWidth',1.5)
    
    [T_turb2,s_turb2,~]=CompressionExpansionPlot(state(3),state(4,1),eta_siT,0,1);
    hold on
    plot(s_turb2,T_turb2,'Color','r','LineStyle','-','LineWidth',1.5)
    
    [T_turb3,s_turb3,~]=CompressionExpansionPlot(state(5),state(6),eta_siT,0,1);
    hold on
    plot(s_turb3,T_turb3,'Color','r','LineStyle','-','LineWidth',1.5)
    
    T=state(4,1).T:abs(state(5).T-state(4,1).T)*0.01:state(5).T;
    sR=zeros(1,length(T));
    for i=1:length(T)
        sR(i)=XSteam('s_pt',state(5).p,T(i));
    end
    hold on
    plot(sR,T,'Color','r','LineStyle','-','LineWidth',1.5)
    
    %% PLOT : condensation in the condenser
    
    hold on
    plot(state(6).s,state(6).T,'o')
    text(state(6).s,state(6).T,'6')
    if isnan(state(6).x)
        %To be done
    else  %case without feedHeating and reHeating
        plot([state(6).s,state(1).s],[state(6).T,state(1).T],'Color','r','LineStyle','-','LineWidth',1.5)
    end
    hold on
    plot(state(3).s,state(3).T,'o')
    text(state(3).s,state(3).T,'3')
    hold on
    plot(state(4,1).s,state(4,1).T,'o')
    text(state(4,1).s,state(4,1).T,'4.1')
    hold on
    plot(state(4,2).s,state(4,2).T,'o')
    text(state(4,2).s,state(4,2).T,'4.2')
    
    hold on
    plot(state(5).s,state(5).T,'o')
    text(state(5).s,state(5).T,'5')
    hold on
    plot(state(6).s,state(6).T,'o')
    text(state(6).s,state(6).T,'6')
    hold on
    plot(state(1).s,state(1).T,'o')
    text(state(1).s,state(1).T,'1')
    hold on
    plot(state(2).s,state(2).T,'o')
    text(state(2).s,state(2).T,'2')
end
end


