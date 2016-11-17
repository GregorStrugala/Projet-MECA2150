function [] = combustion(type,lambda)

fuels=zeros(6,6);

%table containing information about different kind of fuel

%1) C
fuels(1,1)=32780;%HHV [kJ/kg]
fuels(1,2)=5350;%T0S [kJ/kg]
fuels(1,3)=6720;%T0S0 [kJ/kg]
fuels(1,4)=34160;%ec [kJ/kg]
fuels(1,5)=32780;%LHV [kJ/kg]
fuels(1,6)=1.042;%ec/LHV

%2) CH1.8
fuels(1,1)=32780;%HHV [kJ/kg]
fuels(1,2)=5350;%T0S [kJ/kg]
fuels(1,3)=6720;%T0S0 [kJ/kg]
fuels(1,4)=34160;%ec [kJ/kg]
fuels(1,5)=32780;%LHV [kJ/kg]
fuels(1,6)=1.042;%ec/LHV

%3) CH4
fuels(3,1)=55695;%HHV [kJ/kg]
fuels(3,2)=11165;%T0S [kJ/kg]
fuels(3,3)=7685;%T0S0 [kJ/kg]
fuels(3,4)=52215;%ec [kJ/kg]
fuels(3,5)=50150;%LHV [kJ/kg]
fuels(3,6)=1.041;%ec/LHV

%C3H8
fuels(1,1)=32780;%HHV [kJ/kg]
fuels(1,2)=5350;%T0S [kJ/kg]
fuels(1,3)=6720;%T0S0 [kJ/kg]
fuels(1,4)=34160;%ec [kJ/kg]
fuels(1,5)=32780;%LHV [kJ/kg]
fuels(1,6)=1.042;%ec/LHV

%H2
fuels(1,1)=32780;%HHV [kJ/kg]
fuels(1,2)=5350;%T0S [kJ/kg]
fuels(1,3)=6720;%T0S0 [kJ/kg]
fuels(1,4)=34160;%ec [kJ/kg]
fuels(1,5)=32780;%LHV [kJ/kg]
fuels(1,6)=1.042;%ec/LHV

%CO
fuels(1,1)=32780;%HHV [kJ/kg]
fuels(1,2)=5350;%T0S [kJ/kg]
fuels(1,3)=6720;%T0S0 [kJ/kg]
fuels(1,4)=34160;%ec [kJ/kg]
fuels(1,5)=32780;%LHV [kJ/kg]
fuels(1,6)=1.042;%ec/LHV

switch type
    case 'C'
    %specific combustive index for a combustible of the form : CHyOx
    y=0;
    x=0;

    m_a1=((32+3.76*28)*(1+(y-2*x)/4))/(12+y+16*x); %[kg_air/kg_fuel]

    case 'CH1.8'
    
    case 'CH4'
    %specific combustive index for a combustible of the form : CHyOx
    y=4;
    x=0;

    m_a1=((32+3.76*28)*(1+(y-2*x)/4))/(12+y+16*x) %[kg_air/kg_fuel]
    case 'C3H8'
    
    case 'H2'
    
    case 'CO'
    
    otherwise
    %lancer une erreur 
end
end