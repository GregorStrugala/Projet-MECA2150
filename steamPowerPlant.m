function[]=steamPowerPlant(deltaT, Triver, Tmax, steamPressure)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

 %data
% Triver=15;%[°C] T cold : river temperature (in degree)
% Th=525;%[°C] T hot : Max. temperature within the boiler (in degree)
% pmax=200;%[bar] steam pressure (in bar)

global state;
% state : 1, 2, 3, 4
state.p=zeros(1,4);%[bar]
state.T=zeros(1,4);%[°C]
state.h=zeros(1,4);%[kJ/kg]
state.s=zeros(1,4);%[kJ/(kg °C)]
state.x=zeros(1,4);%[/]
Tcond=Triver+deltaT;
%deduced from the datas
state.p(3)=steamPressure;
state.T(1)=Tcond;
state.T(4)=Tcond;
state.T(3)=Tmax;
%assumption Rankine cyle : liquid saturated out the condenseur
state.x(1)=0;

% grace aux hypothese du cycle de Rankine-Hirn
% state.x(1)=0;
% state.x(2)=NaN;
% state.x(3)=NaN;

%state.p(1)=XSteam('psat_T',33);
%state.h(1)=XSteam('hL_p',state.p(1));
%state.s(1)=XSteam('sL_p',state.p(1))
turbine(3,0.88);
condenser(4);
feedPump(1,0.8)
steamGenerator(2)


end
