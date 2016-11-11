function[T,s,h] = vaporizationCondensationPlot(stateLP,stateHP)

%part1
Tsat=XSteam('Tsat_p',stateHP.p);
Tpart1=stateLP.T:(Tsat-stateLP.T)*0.01:Tsat-0.01;
sPart1=zeros(1,length(Tpart1));
for i=1:length(Tpart1)
    sPart1(i)=XSteam('s_pt',stateHP.p,Tpart1(i));
end

%hold on
%plot(sPart1,T,'Color','r','LineStyle','-','LineWidth',1.5)

%part2 & part 3
sV_p=XSteam('sv_p',stateHP.p);
sL_p=XSteam('sl_p',stateHP.p);
if sV_p<stateHP.s
    
    sPart2=[sL_p,sV_p];
    Tpart2=[Tsat,Tsat];
    
    %part3
    Tsur=XSteam('T_ps',stateHP.p,stateHP.s);
    Tpart3=Tsat+0.01:(Tsur-Tsat)*0.01:Tsur;
    sPart3=zeros(1,length(Tpart3));
    %hPart3=zeros(1,length(Tpart3));
    
    
    for i=1:length(Tpart3)
        sPart3(i)=XSteam('s_pt',stateHP.p,Tpart3(i));
    end
    
    T=[Tpart1,Tpart2,Tpart3];
    s=[sPart1,sPart2,sPart3];
    h=[];
    
else
    
    sPart2=[sL_p,stateHP.s];
    Tpart2=[Tsat,stateHP.T];
        
    T=[Tpart1,Tpart2];
    s=[sPart1,sPart2];
    h=[];
end


%hold on
%plot([sL_p sV_p],[Tsat Tsat],'Color','r','LineStyle','-','LineWidth',1.5)





end

