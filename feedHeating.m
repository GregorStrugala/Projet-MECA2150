function[state]=feedHeating(state,pmax,eta_siP,eta_siT,n)
%stateO est une structure condensee contenant les etats compris entre 7 a 1

% TO DO energetic and exergetic analysis !



%% State calculation
for i=1:n
    
hPurge=i*abs(state(3).h-state(4).h)/(n+1)+state(4).h;

[state(7+4*(i-1))]=purge(hPurge,state(3),eta_siT);
[state(8+4*(i-1)),~,~,~,~]=condenser(state(7+4*(i-1)));
[state(9+4*(i-1))]=subcooler(state(8+4*(i-1)),20); %10 est le dT à mettre en argument de la fonction ?
if n==1
    outCondenser=state(5);
    [state(10+4*(i-1))]=valve(state(9+4*(i-1)),outCondenser);
else
    previousHeater=state(10+4*(i-1)-6);
    [state(10+4*(i-1))]=valve(state(9+4*(i-1)),previousHeater);
end
[state(6)]=extractionPump(state(5),0.5,pmax,eta_siP);
%0.3 est la fraction du dP que doit faire la pompe d'extraction ? Mettre en
% %argument ? 30 est pmax
[state(1)]=exchanger(state(6),0.9,state(8+4*(i-1)).T);%est le "rendement avec les echangeurs"

end
end
