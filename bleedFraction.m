function[X]=bleedFraction(state,nF,nR)

A=zeros(nF,nF);
b=zeros(1,nF);
outTurbine=zeros(1,nF);
outValve=zeros(1,nF);
inNextHeater=zeros(1,nF);
outPreviousHeater=zeros(1,nF);
for i=1:nF
    if i==1
        outTurbine(i)=state(4+2*nR,i).h;
        outSubcooler=state(6+2*nR,i).h;
        outValve(i)=outSubcooler;%in Valve in fact, used to be more general
        outExtractPump=state(10+2*nR).h;
        outPreviousHeater(i)=outExtractPump;%no previous heater --> extracting pump
        if i==nF%case with only one feed heating
            inNextHeater(i)=state(1).h;%no next heater --> feedPump
        else%case with more than one feed heating
            inNextHeater(i)=state(11+2*nR,i+1).h;
        end
        
        A(i,i)=(inNextHeater(i)+outValve(i)-(outPreviousHeater(i)+outTurbine(i)));
        b(i)=outPreviousHeater(i)-inNextHeater(i);
    else %i~=1
        outTurbine(i)=state(4+2*nR,i).h;
        outValve(i)=state(6+2*nR,i).h;
        outPreviousHeater(i)=state(11+2*nR,i).h;
        if i==nF%no next heater --> feedPump
            inNextHeater(i)=state(1).h;
        else
            inNextHeater(i)=state(11+2*nR,i+1).h;
        end
        A(i,i)=(inNextHeater(i)+outValve(i)-(outPreviousHeater(i)+outTurbine(i)));
        b(i)=outPreviousHeater(i)-inNextHeater(i);
        for j=1:(i-1)
             A(i,j)=inNextHeater(i)-outPreviousHeater(i);%ok for nF=2 not for nF>2
        end
    end
    
end

b=b';
X=A\b;
end