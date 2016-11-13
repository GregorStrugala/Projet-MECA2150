function[state]=feedHeating(state,pmax,eta_siP,eta_siT,n)
%stateO est une structure condensee contenant les etats compris entre 7 a 1

% TO DO energetic and exergetic analysis !



%% State calculation
for i=1:n
    hPurge=i*abs(state(3).h-state(4).h)/(n+1)+state(4).h;
    
    [state(6)]=extractionPump(state(5),0.5,pmax,eta_siP);
    [state(7+5*(i-1))]=purge(hPurge,state(3),eta_siT);
    [state(8+5*(i-1)),~,~,~,~]=condenser(state(7+5*(i-1)));
    %[state(9+5*(i-1))]=subcooler(state(8+5*(i-1)),20);%20 est le dT. A mettre
    %en argument de la fonction ? FAUX voir page 68 livre de ref
    if i==1
        [state(9)]=subcooler(state(8),state(5).T);
        outCondenser=state(5);
        [state(10)]=valve(state(9),outCondenser);
        [state(11)]=exchanger(state(6),0.9,state(8).T);
    else
        [state(9+5*(i-1))]=subcooler(state(8+5*(i-1)),state(8+5*(i-2)).T);
        previousHeater=state(10+5*(i-1)-7);
        [state(10+5*(i-1))]=valve(state(9+5*(i-1)),previousHeater);
        [state(11+5*(i-1))]=exchanger(state(11+5*(i-2)),0.8,state(8+5*(i-1)).T);
    end
end
%[state(6)]=extractionPump(state(5),0.5,pmax,eta_siP);
%0.3 est la fraction du dP que doit faire la pompe d'extraction ? Mettre en
% %argument ? 30 est pmax
%[state(1)]=exchanger(state(6),0.9,state(8+4*(n-1)).T);%est le "rendement avec les echangeurs"
%[state(1)]=exchanger(state(6),0.9,state(8+5*(n-1)).T);
state(1)=state(11+5*(n-1));

end
