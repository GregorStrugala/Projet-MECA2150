function[X]=bleedFraction(state,nF,nR,indexDeaerator)

A=zeros(nF,nF);%preallocations
b=zeros(1,nF);
%outDeaerator=0;
%TEST : add deaerator
for i=1:nF
    outTurbine=state(4+2*nR,i).h;
    if i==1 && i~=indexDeaerator %il faut gerer le cas ou indexDeaerator==1
        outExtractPump=state(10+2*nR).h;
        outPreviousHeater=outExtractPump;%no previous heater-->extracting pump
        outSubcooler=state(6+2*nR,i).h;%first stage:need to add a subcooler
        inValve=outSubcooler;
        if i==nF%case where there is only one feed-heater
            inFeedPump=state(1).h;
            inNextHeater=inFeedPump;%there is no next stage of heater-->directly in the feed pump
            outValve=0;%no next heater-->no input of fluid
        else%case with multiple feed-heaters
            inNextHeater=state(11+2*nR,i+1).h;%output of the current heater (1) that corresponds at the input of the second heater
            outValve=state(6+2*nR,i+1).h;%input of fluid in the current heater (1)
        end
    elseif i==indexDeaerator %we take into account that there is other heaters before and after
        %gerer le cas ou i==1 && i==nF
        outDeaerator=state(5+2*nR,i).h;
        if i==1
            
        elseif i==nF
            
        end
        %outExtractPump=state(11+2*nR,index).h;
    else
        inValve=state(5+2*nR,i).h;
        outPreviousHeater=state(11+2*nR,i).h;
        if i==nF%case where the i th is the last feed heater
            inNextHeater=state(1).h;%there is no next stage of heater-->directly in the feed pump
            outValve=0;%no next heater-->no input of fluid
        else
            inNextHeater=state(11+2*nR,i+1).h;
            outValve=state(6+2*nR,i+1).h;
        end
    end
    %filling the matrix
    A(i,i)=(outTurbine-inValve);
    b(i)=inNextHeater-outPreviousHeater;
    if i<indexDeaerator
        for j=1:indexDeaerator-1
            if j>i
                A(i,j)=A(i,j)+(outValve-inValve);
            end
            A(i,j)=A(i,j)+(outPreviousHeater-inNextHeater);
        end
    elseif i==indexDeaerator
        A(i,i)=outTurbine;
        b(i)=outDeaerator-outPreviousHeater;
        for j=1:nF
            if j<indexDeaerator
                A(i,j)=A(i,j)+outPreviousHeater;
            elseif j>indexDeaerator
                A(i,j)=A(i,j)+outValve;
            end
            A(i,j)=A(i,j)-outDeaerator;
        end
    else
        for j=1:nF
            if j>i
                A(i,j)=outValve-inValve;
            end
            A(i,j)=A(i,j)+(outPreviousHeater-inNextHeater);
        end
    end
end
b=b';
X=A\b;
%==========================================================================
%CODE WITHOUT DEAERATOR
% for i=1:nF
%     outTurbine=state(4+2*nR,i).h;
%     if i==1 %first bleed:need to add a subcooler !
%         outExtractPump=state(10+2*nR).h;
%         outPreviousHeater=outExtractPump;%no previous heater-->extracting pump
%         outSubcooler=state(6+2*nR,i).h;%first stage:need to add a subcooler
%         inValve=outSubcooler;
%         if i==nF%case where there is only one feed-heater
%             inFeedPump=state(1).h;
%             inNextHeater=inFeedPump;%there is no next stage of heater-->directly in the feed pump
%             outValve=0;%no next heater-->no input of fluid
%         else%case with multiple feed-heaters
%             inNextHeater=state(11+2*nR,i+1).h;%output of the current heater (1) that corresponds at the input of the second heater
%             outValve=state(6+2*nR,i+1).h;%input of fluid in the current heater (1)
%         end
%     else %case of the i th feed heater
%         inValve=state(5+2*nR,i).h;
%         outPreviousHeater=state(11+2*nR,i).h;
%         if i==nF%case where the i th is the last feed heater
%             inNextHeater=state(1).h;%there is no next stage of heater-->directly in the feed pump
%             outValve=0;%no next heater-->no input of fluid
%         else
%             inNextHeater=state(11+2*nR,i+1).h;
%             outValve=state(6+2*nR,i+1).h;
%         end
%     end
%
%     %filling the matrix; system : A*X=b
%     A(i,i)=A(i,i)+(outTurbine-inValve);
%     b(i)=inNextHeater-outPreviousHeater;
%     for j=1:nF
%         if j>i
%             A(i,j)=outValve-inValve;
%         end
%         A(i,j)=A(i,j)+(outPreviousHeater-inNextHeater);
%     end
% end
% b=b';
% X=A\b;
end