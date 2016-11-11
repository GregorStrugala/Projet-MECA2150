function [ ] = Ts_diagram(state,eta_siP,eta_siT,n)
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

[Tvap,sVap,~]=vaporizationCondensationPlot(state(2),state(3));
hold on
plot(sVap,Tvap,'Color','r','LineStyle','-','LineWidth',1.5)

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
elseif n == 0 %case without feedHeating
    plot([state(4).s,state(1).s],[state(4).T,state(1).T],'Color','r','LineStyle','-','LineWidth',1.5)
else
    plot([state(4).s,state(5).s],[state(4).T,state(5).T],'Color','r','LineStyle','-','LineWidth',1.5)
    
end


if n ~= 0 %feedHeating
        
    for i=1:n
        
        %% PLOT : purge steam in the turbine, condensation in the heater and the subcooler
        hold on
        plot(state(7+4*(i-1)).s,state(7+4*(i-1)).T,'o')
        %text(state(7).s,state(7).T,labels(7))
        hold on
        plot(state(8+4*(i-1)).s,state(8+4*(i-1)).T,'o')
        %text(state(8).s,state(8).T,labels(8))
        hold on
        plot(state(9+4*(i-1)).s,state(9+4*(i-1)).T,'o')
        %text(state(9).s,state(9).T,labels(9))
        
        [Tcond,sCond,~]=vaporizationCondensationPlot(state(9+4*(i-1)),state(7+4*(i-1)));
        hold on 
        plot(sCond,Tcond,'Color','b','LineStyle','--','LineWidth',1.5)
        
        %% PLOT : isenthalpic expansion in the valve
        hold on
        plot(state(10+4*(i-1)).s,state(10+4*(i-1)).T,'o')
        %text(state(10).s,state(10).T,labels(10))
        hold on
        plot(state(5).s,state(5).T,'o')
        text(state(5).s,state(5).T,'5','Position',[state(5).s,state(5).T])
        
        [Texp,sExp,~] = isenthalpicExpansion(state(10+4*(i-1)),state(9+4*(i-1)));
        hold on
        plot(sExp,Texp,'Color','b','LineStyle','--','LineWidth',1.5)
        
        %% PLOT : compression in the extracting pump
        hold on
        plot(state(6).s,state(6).T,'o')
        text(state(6).s,state(6).T,'6','Position',[state(6).s,state(6).T])
        
        [Tcomp2,sComp2,~]=CompressionExpansionPlot(state(5),state(6),0.8,1,0);
        hold on
        plot(sComp2,Tcomp2,'Color','r','LineStyle','-','LineWidth',1.5)
        
        %% PLOT : reheating in the different heater
        
        T=state(6).T:abs(state(1).T-state(6).T)*0.01:state(1).T;
        sR=zeros(1,length(T));
        for i=1:length(T)
            sR(i)=XSteam('s_pt',state(1).p,T(i));
        end
        plot(sR,T,'Color','r','LineStyle','-','LineWidth',1.5)
    end
    
    
end
end

