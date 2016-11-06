function[state]=feedHeating(state,pmax,eta_siP,eta_siT)
%stateO est une structure condensee contenant les etats compris entre 7 a 1

% TO DO energetic and exergetic analysis !



%% State calculation
[state(7)]=purge(state,eta_siT);
[state(8),~,~,~,~]=condenser(state(7));
[state(9)]=subcooler(state(8),10); %10 est le dT à mettre en argument de la fonction ?
[state(10)]=valve(state(9),state);
[state(6)]=extractionPump(state(5),0.3,pmax,eta_siP);
%0.3 est la fraction du dP que doit faire la pompe d'extraction ? Mettre en
%argument ? 30 est pmax
[state(1)]=exchanger(state(6),50);%50 est le dT à mettre en argument de la fonction ?

end
