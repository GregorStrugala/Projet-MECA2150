function[T,s,h] = vaporizationCondensationPlot(stateLT,stateHT)
%Assumptions : pressure is constant

% %PROBLEME AVEC CETTE FONCTION !!!
% T=stateLT.T:(stateHT.T-stateLT.T)*0.01:stateHT.T;
% sV_p=XSteam('sv_p',stateHT.p);
% sL_p=XSteam('sl_p',stateHT.p);
% Tsat=XSteam('Tsat_p',stateHT.p);
% for i=1:length(T)
%     s(i)=XSteam('s_pT', stateLT.p,T(i));
%     h(i)=XSteam('h_pT',stateLT.p,T(i));
% end
sV_p=XSteam('sv_p',stateHT.p);

if isnan(sV_p)
    T=stateLT.T:(stateHT.T-stateLT.T)*0.01:stateHT.T;
    for i=1:length(T)
        s(i)=XSteam('s_pT', stateLT.p,T(i));
        h(i)=XSteam('h_pT',stateLT.p,T(i));
    end
else
    Tsat=XSteam('Tsat_p',stateHT.p);
    Tpart1=stateLT.T:(Tsat-stateLT.T)*0.01:Tsat-0.01;
    sPart1=zeros(1,length(Tpart1));
    for i=1:length(Tpart1)
        if i == 1
            sPart1(i)=stateLT.s;
        else
            sPart1(i)=XSteam('s_pt',stateHT.p,Tpart1(i));
        end
    end
    
    %part2 & part 3
    sV_p=XSteam('sv_p',stateHT.p);
    sL_p=XSteam('sl_p',stateHT.p);
    if sV_p<stateHT.s
        
        sPart2=[sL_p,sV_p];
        Tpart2=[Tsat,Tsat];
        
        %part3
        Tsur=XSteam('T_ps',stateHT.p,stateHT.s);
        Tpart3=Tsat+0.01:(Tsur-Tsat)*0.01:Tsur;
        sPart3=zeros(1,length(Tpart3));
        %hPart3=zeros(1,length(Tpart3));
        
        
        for i=1:length(Tpart3)
            if i == length(Tpart3)
                sPart3(i)=stateHT.s;
            end
            sPart3(i)=XSteam('s_pt',stateHT.p,Tpart3(i));
        end
        
        T=[Tpart1,Tpart2,Tpart3];
        s=[sPart1,sPart2,sPart3];
        h=[];
        
    else
        sPart2=[sL_p,stateHT.s];
        Tpart2=[Tsat,stateHT.T];
        
        T=[Tpart1,Tpart2];
        s=[sPart1,sPart2];
        h=[];
    end
end
end

