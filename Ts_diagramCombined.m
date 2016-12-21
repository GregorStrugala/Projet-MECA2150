function [ ] = Ts_diagramCombined(state,eta_siP,eta_siT,pressureLevel)
%Note : changer les noms des variables, peu coherent
%mettre commentaires
%Faire un beau graphe !
%global state

Tvap=0.1:5:373.9459;

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
plot([sl_t fliplr(sv_t)], [Tvap fliplr(Tvap)],'Color','g','LineStyle','-','LineWidth',1.5)% no hole
xlabel('s [kJ/(kg K)]')
ylabel('T [°C]')


switch pressureLevel
    %% %%%%%%%%%%%%%%%%%%% COMBINED CYCLE POWER PLANT (2P) %%%%%%%%%%%%%%%%%%%%
    
    case '2P'
        %Total flow
        [Tcomp,sComp,~]=CompressionExpansionPlot(state(1),state(2),eta_siP,1,0);
        hold on
        plot(sComp,Tcomp,'Color','m','LineStyle','-','LineWidth',1.5)
        
        
        [Tvap1,sVap1,~]=vaporizationCondensationPlot(state(2),state(2,2));
        hold on
        plot(sVap1,Tvap1,'Color','m','LineStyle','-','LineWidth',1.5)
        
        %LP flow
        [Tvap2,sVap2,~]=vaporizationCondensationPlot(state(2,2),state(4));
        hold on
        plot(sVap2,Tvap2,'Color','r','LineStyle','-','LineWidth',1.5)
        
        %expansion in the turbine
        [T_turb,s_turb,~]=CompressionExpansionPlot(state(4),state(5),eta_siT,0,1);
        hold on
        plot(s_turb,T_turb,'Color','m','LineStyle','-','LineWidth',1.5)
        
        % PLOT : condensation in the condenser
        hold on
        plot(state(5).s,state(5).T,'o')
        text(state(5).s,state(5).T,'4')
        if isnan(state(5).x)
            
            %To be done
        else  %case without feedHeating and reHeating
            plot([state(5).s,state(1).s],[state(5).T,state(1).T],'Color','m','LineStyle','-','LineWidth',1.5)
        end
        
        %HP flow
        [Tcomp2,sComp2,~]=CompressionExpansionPlot(state(2,2),state(6,1),eta_siP,1,0);
        hold on
        plot(sComp2,Tcomp2,'Color','b','LineStyle','-','LineWidth',1.5)
        
        [Tvap2,sVap2,~]=vaporizationCondensationPlot(state(6,1),state(3));
        hold on
        plot(sVap2,Tvap2,'Color','b','LineStyle','-','LineWidth',1.5)
        
        %expansion in the turbine
        [T_turb,s_turb,~]=CompressionExpansionPlot(state(3),state(4),eta_siT,0,1);
        hold on
        plot(s_turb,T_turb,'Color','b','LineStyle','-','LineWidth',1.5)
        %==============================================================================
        %FOR TEST
        hold on
        plot(state(1).s,state(1).T,'o')
        text(state(1).s,state(1).T,'1')
        
        hold on
        plot(state(2,1).s,state(2,1).T,'o')
        text(state(2,1).s,state(2,1).T,'2')
        
        hold on
        plot(state(2,2).s,state(2,2).T,'o')
        text(state(2,2).s,state(2,2).T,'2''')
        
        hold on
        plot(state(2,3).s,state(2,3).T,'o')
        text(state(2,3).s,state(2,3).T,'2''''')
        
        hold on
        plot(state(3).s,state(3).T,'o')
        text(state(3).s,state(3).T,'3')
        
        hold on
        plot(state(4).s,state(4).T,'o')
        text(state(4).s,state(4).T,'4')
        
        hold on
        plot(state(5).s,state(5).T,'o')
        text(state(5).s,state(5).T,'5')
        
        hold on
        plot(state(6,1).s,state(6,1).T,'o')
        text(state(6,1).s,state(6,1).T,'9')
        
        hold on
        plot(state(6,2).s,state(6,2).T,'o')
        text(state(6,2).s,state(6,2).T,'9p')
        
        hold on
        plot(state(6,3).s,state(6,3).T,'o')
        text(state(6,3).s,state(6,3).T,'9"')
        
        
        
    case '3P'
        %% %%%%%%%%%%%%%%%%%%% COMBINED CYCLE POWER PLANT (3P) %%%%%%%%%%%%%%%%%%%%
        %==============================================================================
        %POINTS
        hold on
        plot(state(1).s,state(1).T,'o')
        text(state(1).s,state(1).T,'1')
        
        hold on
        plot(state(2,1).s,state(2,1).T,'o')
        text(state(2,1).s,state(2,1).T,'2')
        
        hold on
        plot(state(2,2).s,state(2,2).T,'o')
        text(state(2,2).s,state(2,2).T,'2p')
        
        hold on
        plot(state(2,3).s,state(2,3).T,'o')
        text(state(2,3).s,state(2,3).T,'2"')
        
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
        plot(state(7).s,state(7).T,'o')
        text(state(7).s,state(7).T,'7')
        hold on
        plot(state(8).s,state(8).T,'o')
        text(state(8).s,state(8).T,'8')
        
        hold on
        plot(state(9,1).s,state(9,1).T,'o')
        text(state(9,1).s,state(9,1).T,'91')
        hold on
        plot(state(9,2).s,state(9,2).T,'o')
        text(state(9,2).s,state(9,2).T,'92')
        
        hold on
        plot(state(9,3).s,state(9,3).T,'o')
        text(state(9,3).s,state(9,3).T,'93')
        hold on
        plot(state(9,4).s,state(9,4).T,'o')
        text(state(9,4).s,state(9,4).T,'94')
        hold on
        plot(state(10,1).s,state(10,1).T,'o')
        text(state(10,1).s,state(10,1).T,'101')
        hold on
        plot(state(10,2).s,state(10,2).T,'o')
        text(state(10,2).s,state(10,2).T,'102')
        
        hold on
        plot(state(10,3).s,state(10,3).T,'o')
        text(state(10,3).s,state(10,3).T,'103')
        
        %Total flow
        [Tcomp,sComp,~]=CompressionExpansionPlot(state(1),state(2),eta_siP,1,0);
        hold on
        plot(sComp,Tcomp,'Color','r','LineStyle','-','LineWidth',1.5)
        
        [Tvap1,sVap1,~]=vaporizationCondensationPlot(state(2),state(2,2));
        hold on
        plot(sVap1,Tvap1,'Color','m','LineStyle','-','LineWidth',1.5)
        
        % PLOT : condensation in the condenser
    
        if isnan(state(7).x)
            
            %To be done
        else  %case without feedHeating and reHeating
            plot([state(7).s,state(1).s],[state(7).T,state(1).T],'Color','m','LineStyle','-','LineWidth',1.5)
        end
        
        [T_turb,s_turb,~]=CompressionExpansionPlot(state(6),state(7),eta_siT,0,1);
        hold on
        plot(s_turb,T_turb,'Color','m','LineStyle','-','LineWidth',1.5)
        
        %LP flow
        [Tvap2,sVap2,~]=vaporizationCondensationPlot(state(2,2),state(6));
        hold on
        plot(sVap2,Tvap2,'Color','r','LineStyle','-','LineWidth',1.5)
        
        %IP flow
        [Tvap2,sVap2,~]=vaporizationCondensationPlot(state(2,2),state(9,4));
        hold on
        plot(sVap2,Tvap2,'Color','c','LineStyle','-','LineWidth',1.5)
                
        %HP flow
        [Tvap2,sVap2,~]=vaporizationCondensationPlot(state(9,2),state(3));
        hold on
        plot(sVap2,Tvap2,'Color','b','LineStyle','-','LineWidth',1.5)
        
        [T_turb,s_turb,~]=CompressionExpansionPlot(state(3),state(4,1),eta_siT,0,1);
        hold on
        plot(s_turb,T_turb,'Color','b','LineStyle','-','LineWidth',1.5)
        
        [T_turb,s_turb,~]=CompressionExpansionPlot(state(4,1),state(4,2),eta_siT,0,1);
        hold on
        plot(s_turb,T_turb,'Color','b','LineStyle','-.','LineWidth',1.5)
        
        % HP +IP flow
        
        Tsur2=XSteam('T_ps',state(5).p,state(5).s);
        Tsur1=XSteam('T_ps',state(5).p,state(9,4).s);
        
        T=Tsur1+0.01:(Tsur2-Tsur1)*0.1:Tsur2;
        s=zeros(1,length(T));
        %h=zeros(1,length(T));
        for i=1:length(T)
            if i == length(T)
                s(i)=state(5).s;
                %hPart3(i)=state(5).h;
            end
            s(i)=XSteam('s_pt',state(5).p,T(i));
            %hPart3(i)=XSteam('h_pt',state(5).p,T(i));
        end
        plot(s,T,'Color','y','LineStyle','-','LineWidth',1.5)
        
        [T_turb,s_turb,~]=CompressionExpansionPlot(state(5),state(6),eta_siT,0,1);
        hold on
        plot(s_turb,T_turb,'Color','y','LineStyle','-','LineWidth',1.5)
        
        
        
        
end
end