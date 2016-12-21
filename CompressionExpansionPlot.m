function[T,s,h]=CompressionExpansionPlot(stateI,stateO,eta_si,compression,expansion)
%% feedPumpCompression plot
%CODE A VERIFIER !!!!! OK VALABLE QUE LORSQUE LE TITRE EST DEFINI CAD
%LORSQUE L ETAT 4 EST DANS LA CLOCHE --> a modifier
%     hold on
%     plot(stateI.s,stateI.T,'o')
%     text(stateI.s,stateI.T,'1')

if compression == 1
    p=stateI.p:abs((stateO.p-stateI.p))*0.1:stateO.p;
    hs=zeros(1,length(p));
    h=zeros(1,length(p));
    s=zeros(1,length(p));
    T=zeros(1,length(p));
    for i=1:length(p)
        if i == 1
            hs(i)=stateI.h;%XSteam('h_ps',p(i),state.s(1));
            h(i)=stateI.h;
            s(i)=stateI.s;
            T(i)=stateI.T;
            
        elseif i==length(p)
            h(i)=stateO.h;
            s(i)=stateO.s;
            T(i)=stateO.T;
        else
            hs(i)=XSteam('h_ps',p(i),stateI.s);
            h(i)=((hs(i)-stateI.h))/eta_si+stateI.h;
            s(i)=XSteam('s_ph',p(i),h(i));
            T(i)=XSteam('T_ps',p(i),s(i));
        end
    end
    
elseif expansion == 1
    p=stateO.p:abs((stateI.p-stateO.p))*0.1:stateI.p;
    p = fliplr(p);
    hs=zeros(1,length(p));
    h=zeros(1,length(p));
    s=zeros(1,length(p));
    T=zeros(1,length(p));
    for i=1:length(p)
        if i == 1
            hs(i)=stateO.h;%XSteam('h_ps',p_pump(i),state.s(1));
            h(i)=stateI.h;
            s(i)=stateI.s;
            T(i)=stateI.T;
            
        elseif i==length(p)
            h(i)=stateO.h;
            s(i)=stateO.s;
            T(i)=stateO.T;
        else
            hs(i)=XSteam('h_ps',p(i),stateI.s);
            h(i)=-((stateI.h)-hs(i))*eta_si+stateI.h;
            s(i)=XSteam('s_ph',p(i),h(i));
            T(i)=XSteam('T_ps',p(i),s(i));
        end
    end
else
    %lancer une erreur
end
end