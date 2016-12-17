function [ ] = hs_diagramCombined(state,eta_siP,eta_siT,pressureLevel)
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
% diagram h-s
%plot(sl_t,h_psl,sv_t,h_psv)
plot([sl_t fliplr(sv_t)], [h_psl fliplr(h_psv)],'Color','g','LineStyle','-','LineWidth',1.5)%no hole

switch pressureLevel
    %% %%%%%%%%%%%%%%%%%%% COMBINED CYCLE POWER PLANT (2P) %%%%%%%%%%%%%%%%%%%%
    
    case '2P'
        %Total flow
        [~,sComp,hComp]=CompressionExpansionPlot(state(1),state(2),eta_siP,1,0);
        hold on
        plot(sComp,hComp,'Color','m','LineStyle','-','LineWidth',1.5)
        
        
        [~,sVap1,hVap1]=vaporizationCondensationPlot(state(2),state(2,2));
        hold on
        plot(sVap1,hVap1,'Color','m','LineStyle','-','LineWidth',1.5)
        
        %LP flow
        [~,sVap1,hVap1]=vaporizationCondensationPlot(state(2,2),state(4));
        hold on
        plot(sVap1,hVap1,'Color','r','LineStyle','-','LineWidth',1.5)
        
        %expansion in the turbine
        [~,s_turb,h_turb]=CompressionExpansionPlot(state(4),state(5),eta_siT,0,1);
        hold on
        plot(s_turb,h_turb,'Color','m','LineStyle','-','LineWidth',1.5)
        
        % PLOT : condensation in the condenser
        hold on
        plot(state(5).s,state(5).h,'o')
        text(state(5).s,state(5).h,'4')
        if isnan(state(5).x)
            
            %To be done
        else  %case without feedHeating and reHeating
            plot([state(5).s,state(1).s],[state(5).h,state(1).h],'Color','m','LineStyle','-','LineWidth',1.5)
        end
        
        %HP flow
        [~,sComp2,hComp2]=CompressionExpansionPlot(state(2,2),state(6,1),eta_siP,1,0);
        hold on
        plot(sComp2,hComp2,'Color','b','LineStyle','-','LineWidth',1.5)
        
        [~,sVap2,hVap2]=vaporizationCondensationPlot(state(6,1),state(3));
        hold on
        plot(sVap2,hVap2,'Color','b','LineStyle','-','LineWidth',1.5)
        
        %expansion in the turbine
        [~,s_turb,h_turb]=CompressionExpansionPlot(state(3),state(4),eta_siT,0,1);
        hold on
        plot(s_turb,h_turb,'Color','b','LineStyle','-','LineWidth',1.5)
                
        %==============================================================================
        %FOR TEST
        hold on
        plot(state(1).s,state(1).h,'o')
        text(state(1).s,state(1).h,'1')
        
        hold on
        plot(state(2,1).s,state(2,1).h,'o')
        text(state(2,1).s,state(2,1).h,'2')
        
        hold on
        plot(state(2,2).s,state(2,2).h,'o')
        text(state(2,2).s,state(2,2).h,'2p')
        
        hold on
        plot(state(2,3).s,state(2,3).h,'o')
        text(state(2,3).s,state(2,3).h,'2"')
        
        hold on
        plot(state(3).s,state(3).h,'o')
        text(state(3).s,state(3).h,'3')
        
        hold on
        plot(state(4).s,state(4).h,'o')
        text(state(4).s,state(4).h,'4')
        
        hold on
        plot(state(5).s,state(5).h,'o')
        text(state(5).s,state(5).h,'5')
        
        hold on
        plot(state(6,1).s,state(6,1).h,'o')
        text(state(6,1).s,state(6,1).h,'9')
        
        hold on
        plot(state(6,2).s,state(6,2).h,'o')
        text(state(6,2).s,state(6,2).h,'9p')
        
        hold on
        plot(state(6,3).s,state(6,3).h,'o')
        text(state(6,3).s,state(6,3).h,'9"')
        
        
        
    case '3P'
        %% %%%%%%%%%%%%%%%%%%% COMBINED CYCLE POWER PLANT (3P) %%%%%%%%%%%%%%%%%%%%
        %==============================================================================
        %POINTS
        hold on
        plot(state(1).s,state(1).h,'o')
        text(state(1).s,state(1).h,'1')
        
        hold on
        plot(state(2,1).s,state(2,1).h,'o')
        text(state(2,1).s,state(2,1).h,'2')
        
        hold on
        plot(state(2,2).s,state(2,2).h,'o')
        text(state(2,2).s,state(2,2).h,'2p')
        
        hold on
        plot(state(2,3).s,state(2,3).h,'o')
        text(state(2,3).s,state(2,3).h,'2"')
        
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
        plot(state(7).s,state(7).h,'o')
        text(state(7).s,state(7).h,'7')
        hold on
        plot(state(8).s,state(8).h,'o')
        text(state(8).s,state(8).h,'8')
        
        hold on
        plot(state(9,1).s,state(9,1).h,'o')
        text(state(9,1).s,state(9,1).h,'91')
        hold on
        plot(state(9,2).s,state(9,2).h,'o')
        text(state(9,2).s,state(9,2).h,'92')
        
        hold on
        plot(state(9,3).s,state(9,3).h,'o')
        text(state(9,3).s,state(9,3).h,'93')
        hold on
        plot(state(9,4).s,state(9,4).h,'o')
        text(state(9,4).s,state(9,4).h,'94')
        hold on
        plot(state(10,1).s,state(10,1).h,'o')
        text(state(10,1).s,state(10,1).h,'101')
        hold on
        plot(state(10,2).s,state(10,2).h,'o')
        text(state(10,2).s,state(10,2).h,'102')
        
        hold on
        plot(state(10,3).s,state(10,3).h,'o')
        text(state(10,3).s,state(10,3).h,'103')
        
        %Total flow
        [~,sComp,hComp]=CompressionExpansionPlot(state(1),state(2),eta_siP,1,0);
        hold on
        plot(sComp,hComp,'Color','r','LineStyle','-','LineWidth',1.5)
        
        [~,sVap1,hVap1]=vaporizationCondensationPlot(state(2),state(2,2));
        hold on
        plot(sVap1,hVap1,'Color','m','LineStyle','-','LineWidth',1.5)
        
        % PLOT : condensation in the condenser
    
        if isnan(state(7).x)
            
            %To be done
        else  %case without feedHeating and reHeating
            plot([state(7).s,state(1).s],[state(7).h,state(1).h],'Color','m','LineStyle','-','LineWidth',1.5)
        end
        
        [~,s_turb,h_turb]=CompressionExpansionPlot(state(6),state(7),eta_siT,0,1);
        hold on
        plot(s_turb,h_turb,'Color','m','LineStyle','-','LineWidth',1.5)
        
        %LP flow
        [~,sVap2,hVap2]=vaporizationCondensationPlot(state(2,2),state(6));
        hold on
        plot(sVap2,hVap2,'Color','r','LineStyle','-','LineWidth',1.5)
        
        %IP flow
        [~,sVap2,hVap2]=vaporizationCondensationPlot(state(2,2),state(9,4));
        hold on
        plot(sVap2,hVap2,'Color','c','LineStyle','-','LineWidth',1.5)
                
        %HP flow
        [~,sVap2,hVap2]=vaporizationCondensationPlot(state(9,2),state(3));
        hold on
        plot(sVap2,hVap2,'Color','b','LineStyle','-','LineWidth',1.5)
        
        [~,s_turb,h_turb]=CompressionExpansionPlot(state(3),state(4,1),eta_siT,0,1);
        hold on
        plot(s_turb,h_turb,'Color','b','LineStyle','-','LineWidth',1.5)
        
        [~,s_turb,h_turb]=CompressionExpansionPlot(state(4,1),state(4,2),eta_siT,0,1);
        hold on
        plot(s_turb,h_turb,'Color','b','LineStyle','-.','LineWidth',1.5)
        
        % HP +IP flow
        
        Tsur2=XSteam('T_ps',state(5).p,state(5).s);
        Tsur1=XSteam('T_ps',state(5).p,state(9,4).s);
        
        T=Tsur1+0.01:(Tsur2-Tsur1)*0.01:Tsur2;
        s=zeros(1,length(T));
        h=zeros(1,length(T));
        for i=1:length(T)
            if i == length(T)
                s(i)=state(5).s;
                h(i)=state(5).h;
            end
            s(i)=XSteam('s_pt',state(5).p,T(i));
            h(i)=XSteam('h_pt',state(5).p,T(i));
        end
        plot(s,h,'Color','y','LineStyle','-','LineWidth',1.5)
        
        [~,s_turb,h_turb]=CompressionExpansionPlot(state(5),state(6),eta_siT,0,1);
        hold on
        plot(s_turb,h_turb,'Color','y','LineStyle','-','LineWidth',1.5)
        
end
end