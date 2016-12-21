function[T,s,h] = isenthalpicExpansion(stateLP,stateHP)

T=stateLP.T:abs(stateLP.T-stateHP.T)*0.1:stateHP.T;
p=linspace(stateLP.p,stateHP.p,length(T));
p=fliplr(p);
T=fliplr(T);
s=zeros(1,length(p));
h=ones(1,length(p));
for i=1:length(p)
    if i==1
        s(i)=stateHP.s;
    elseif i==length(p)
        s(i)=stateLP.s;
    else
     s(i)=XSteam('s_ph',p(i),stateHP.h);
    end
 end
h=stateHP.h*h;
end