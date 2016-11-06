function [ ] = Ts_diagram(state,eta_siP,eta_siT,n)
%Note : changer les noms des variables, peu coherent
%mettre commentaires
%Faire un beau graphe !
%global state

T=0.1:0.1:373.9459;

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
% diagram T-s
%plot(sl_t,T,sv_t,T)
plot([sl_t fliplr(sv_t)], [T fliplr(T)])% no hole

if n==0 %case without feedHeating
    
    %% PLOT : compression in the feed pump
    %CODE A VERIFIER !!!!! OK VALABLE QUE LORSQUE LE TITRE EST DEFINI CAD
    %LORSQUE L ETAT 4 EST DANS LA CLOCHE --> a modifier
    hold on
    plot(state(1).s,state(1).T,'o')
    text(state(1).s,state(1).T,'1')
    
    [Tcomp,sComp,~]=CompressionExpansionPlot(state(1),state(2),eta_siP,1,0);
    hold on
    plot(sComp,Tcomp)
    
    
    %% PLOT : vaporization in the steam generator
    
    hold on
    plot(state(2).s,state(2).T,'o')
    text(state(2).s,state(2).T,'2')
    
    %part1
    Tsat_Gen=XSteam('Tsat_p',state(3).p);
    T_Gen1=state(2).T:(Tsat_Gen-state(2).T)*0.01:Tsat_Gen-0.01;
    sGen1=zeros(1,length(T_Gen1));
    for i=1:length(T_Gen1)
        sGen1(i)=XSteam('s_pt',state(3).p,T_Gen1(i));
    end
    
    hold on
    plot(sGen1,T_Gen1)
    
    %part2
    sV_pGen=XSteam('sv_p',state(3).p);
    sL_pGen=XSteam('sl_p',state(3).p);
    
    hold on
    plot([sL_pGen sV_pGen],[Tsat_Gen Tsat_Gen])
    
    %part3
    Tsur_Gen2=XSteam('T_ps',state(3).p,state(3).s);
    T_Gen2=Tsat_Gen:(Tsur_Gen2-Tsat_Gen)*0.01:Tsur_Gen2;
    sGen2=zeros(1,length(T_Gen2));
    
    for i=1:length(T_Gen2)
        sGen2(i)=XSteam('s_pt',state(3).p,T_Gen2(i));
    end
    
    hold on
    plot(sGen2,T_Gen2)
    
    %% PLOT : Expansion in the turbine
    hold on
    plot(state(3).s,state(3).T,'o')
    text(state(3).s,state(3).T,'3')
    
    [T_turb,s_turb,h_turb]=CompressionExpansionPlot(state(3),state(4),eta_siT,0,1);
    hold on
    plot(s_turb,T_turb)
    
    %% PLOT : condensation in the condenser
    hold on
    plot(state(4).s,state(4).T,'o')
    text(state(4).s,state(4).T,'4')
    if isnan(state(4).x)
        
        %To be done
    else
        plot([state(4).s,state(1).s],[state(4).T,state(1).T])
    end
    
else
    
    %% feedHeating
    labels = cellstr( num2str([1:10]') );  %' # labels correspond to their order
    hold on
    plot(state(7).s,state(7).T,'o')
    text(state(7).s,state(7).T,labels(7))
    hold on
    plot(state(8).s,state(8).T,'o')
    text(state(8).s,state(8).T,labels(8))
    hold on
    plot(state(9).s,state(9).T,'o')
    text(state(9).s,state(9).T,labels(9))
    hold on
    plot(state(10).s,state(10).T,'o')
    text(state(10).s,state(10).T,labels(10))
    hold on
    plot(state(6).s,state(6).T,'*')
    text(state(6).s,state(6).T,labels(6))
    
    hold on
    plot(state(5).s,state(5).T,'*')
    text(state(5).s,state(5).T,labels(5))
    hold on
    plot(state(4).s,state(4).T,'*')
    text(state(4).s,state(4).T,labels(4))
    
    hold on
    plot(state(3).s,state(3).T,'*')
    text(state(3).s,state(3).T,labels(3))
    
    hold on
    plot(state(2).s,state(2).T,'*')
    text(state(2).s,state(2).T,labels(2))
    hold on
    plot(state(1).s,state(1).T,'*')
    text(state(1).s,state(1).T,labels(1))
end


end

