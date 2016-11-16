function[T,s,h] = isenthalpicExpansion(stateLP,stateHP)

T=stateLP.T:abs(stateLP.T-stateHP.T)*0.001:stateHP.T;
p=linspace(stateLP.p,stateHP.p,length(T));
p=fliplr(p);
T=fliplr(T);
s=zeros(1,length(p));
for i=1:length(p)
     s(i)=XSteam('s_ph',p(i),stateHP.h);
 end
h=stateHP.h;
end