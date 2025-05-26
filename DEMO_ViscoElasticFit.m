%% Demo: Fitting ViscoElastic Model to Raw Data

clear; clc; close all

%import raw data
load dependencies/RawUniaxialData.mat

%visualize raw data from ramp-hold-ramp to failure test
plot(t(1:t1i),S(1:t1i),'linewidth',2,'displayname','Ramp'); hold on
plot(t(t1i:t2i),S(t1i:t2i),'linewidth',2,'displayname','Hold'); hold on
xlabel('time [s]')
ylabel('stress [MPa]')
% plot(t(t2i:end),S(t2i:end),'linewidth',2,'displayname','Ramp'); hold on
legend('location','northeast')
set(gca,'fontsize',16)

%create a time vector to interpolate from. Let's just fit to the ramp-hold
%portion of the data for this test
time = [linspace(0,t(t1i-2),40) logspace(log10(t(t1i)),log10(t(t2i)),40)];

%create decimated datasets for fitting
strain = interp1(t,s,time);
stress = interp1(t,S,time);
%plot(time,stress,'k.','markersize',10,'HandleVisibility','off'); hold on

%initialze a guess for Einf - the long term modulus. If using a nonlinear
%elasticity model, you'll need to initialize more coefficients
Einf = 1.5*S(t1i)/s(t1i);

%intialize some guesses for g_i and tau_i. The length of these vectors
%determines the prony series order (must be the same length)
g = [0.25 0.25 0.2]; %these must sum to <1
tau = [0.1 2 10]; %usually separate these by an order of magnitude

%reshape the inputs into a vector of initial guesses
X0 = [Einf reshape([g; tau],1,[])];

%formulate a constraint system to prevent sum(g_i) from exceeding 1.0
%(remember, g_i is stored in X0(2:2:end))
A = zeros(2*length(g)+1);
A(1,2:2:end) = 1;
b = zeros(2*length(g)+1,1);
b(1) = 1; 

%define lower and upper bounds on variables. 
lb = zeros(2*length(g)+1,1);
ub = [2*Einf reshape([ones(1,length(g)); 10*g], 1,[])];

%solve for the model coefficients
options = optimset('MaxFunEvals',1000);
X = fmincon(@(X) errorFunc(X,time,strain,t,S,0),X0,A,b,[],[],lb,ub,[],options);

%rerun with plotting option enabled
errorFunc(X,time,strain,t,S,1);

%check against analytical solution (this works for LE ramp hold only)
Sanalytical = eval_LE_Prony_CloseFormRampHold(t(t1i),s(t1i),X(1),X(2:2:end),X(3:2:end),time);
plot(time,Sanalytical,'k.','displayname','Analytical Prony','markersize',10)

function e = errorFunc(X,time,strain,t,S,plotme)

%extract the coefficients
Einf = X(1);
g = X(2:2:end);
tau = X(3:2:end);

%generate a stress vs time response
Sfit = computeViscoElasticResponse(time,strain,g,tau,'LE',Einf);

error = (interp1(t,S,time)'-Sfit);

e = sumsqr(error);

if plotme
    %plot fit data
    plot(time,Sfit,'k--','linewidth',1.5,'DisplayName','Discrete Prony Fit')
    set(gca,'fontname','georgia','fontsize',16)
    
    %print model coefficients
    fprintf('\n E0: %1.3f\n',X(1));
    fprintf(' gi: \t tau:\n ---\t ----\n');
    fprintf('%1.2f \t %1.2f\n',X(2:end));
    drawnow
end

end
