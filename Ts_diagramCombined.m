function [ ] = Ts_diagramCombined(state,eta_siP,eta_siT)
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

%% %%%%%%%%%%%%%%%%%%% COMBINED CYCLE POWER PLANT (2P) %%%%%%%%%%%%%%%%%%%%
%==============================================================================
    %FOR TEST
        hold on
        plot(state(1,1).s,state(1,1).T,'o')
        text(state(1,1).s,state(1,1).T,'1')
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
        plot(state(3,1).s,state(3,1).T,'o')
        text(state(3,1).s,state(3,1).T,'3')
        hold on
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
        hold on
        plot(state(5,1).s,state(5,1).T,'o')
        text(state(5,1).s,state(5,1).T,'5.1')
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
        hold on
        plot(state(4).s,state(4).T,'o')
        text(state(4).s,state(4).T,'8')
    hold on
    plot(state(6,1).s,state(6,1).T,'o')
    text(state(6,1).s,state(6,1).T,'9')
    hold on
    plot(state(6,2).s,state(6,2).T,'o')
    text(state(6,2).s,state(6,2).T,'9p')
    hold on
    plot(state(6,3).s,state(6,3).T,'o')
    text(state(6,3).s,state(6,3).T,'9"')
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
    
    [T_turb,s_turb,~]=CompressionExpansionPlot(state(3,1),state(5,1),eta_siT,0,1);
    hold on
        plot(s_turb,T_turb,'Color','r','LineStyle','-','LineWidth',1.5)
    
end