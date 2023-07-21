function [S] = eval_LE_Prony_CloseFormRampHold(t1,s1,E0,g,tau,time)

%closed form evaluation of linear elastic linear viscoelastic response to
%ramp hold test using the method of Chen 2000
%https://ntrs.nasa.gov/api/citations/20000052499/downloads/20000052499.pdf

t_step1 = time(time<t1);
S0 = E0*s1/t1;
S1 = S0*t_step1;
for i = 1:length(g)
    S1 = S1 + S0 * ( -g(i)*t_step1...
                    +g(i)*tau(i)...
                    -g(i)*tau(i)*exp(-t_step1/tau(i)));
end

t_step2 = time(time>=t1);
S2 = S0*t1;
for i = 1:length(g)
    S2 = S2 + S0 *( -g(i)*t1...
                    +g(i)*tau(i)*exp(-(t_step2-t1)/tau(i))...
                    -g(i)*tau(i)*exp(-t_step2/tau(i)));
end

S = [S1 S2];
end