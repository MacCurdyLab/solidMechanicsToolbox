function [S] = evalOgdenNP_PronyNP(t,L,mu,alpha,g,tau)

S0 = OgdenNP(L,mu,alpha);
S = S0(1);
dS0dt = gradient(S0,t);
ginf = g(1);
g(1) = [];

for n = 2:length(t)
    
    dt = t(n)-t(n-1);

    for i = 1:length(g)

    if n>2
        %Equation 5 of Goh 2014
        hi = trapz(t(1:n-1), ...
            g(i)*exp(-(t(n-1)-t(1:n-1))/tau(i))...
            .*dS0dt(1:n-1));
    else
        hi=0;
    end
    
    
    %store this Prony Term as another Sn entry
    Sn(i) =  exp(-dt/tau(i))*hi ...
             +g(i)*(1-exp(-dt/tau(i)))/(dt/tau(i))...
             *(S0(n)-S0(n-1));
    end

    %Equation 12 of Goh 2014
    Sr = ginf*S0(n)+sum(Sn);

    %append this stress to the stress vector
    S=[S; Sr];

end

end