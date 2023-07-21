%% Demo: fitting hyperelasticity model to test data

clear; clc; close all

data = importdata('dependencies\Diabase X60.txt');

plot(data(:,2),data(:,3),'r.','linewidth',2,'displayname',...
    'Raw Data','markersize',20); hold on
xlabel('Stretch')
ylabel('Stress [MPa]')
legend('location','northwest')

%create some guesses for mu and alpha parameters in ogden model
%the lenth of these vectors determines the order of the ogden model
mu = [0.2 0.5];
alpha = [0.5 -0.5];

%reshape into vector of initial guesses
strain = data(:,2);
stress = data(:,3);
X0 = reshape([mu; alpha],1,[]);

%define upper and lower limits for guesses
lb = -inf(size(X0));
lb(1:2:end) = 0;
ub = inf(size(X0));

%solve for the model coefficients
options = optimset('MaxFunEvals',1000);
X = fmincon(@(X) errorFunc(X,strain,stress,0),X0,[],[],[],[],lb,ub,[],options);

errorFunc(X,strain,stress,1);

function e = errorFunc(X,strain,stress,plotme)

%extract the coefficients
mu = X(1:2:end);
alpha = X(2:2:end);

%generate a stress vs time response
Sfit = computeHyperElasticResponse(strain,'OG',mu,alpha);

error = stress-Sfit;

e = sumsqr(error);

if plotme
    %plot fit data
    plot(strain,Sfit,'k--','linewidth',1.5,'DisplayName','Discrete Prony Fit')
    set(gca,'fontname','georgia','fontsize',16)
    
    %print model coefficients
    fprintf(' mu: \t alpha:\n ---\t ----\n');
    fprintf('%1.2f \t %1.2f\n',X(1:end));
    drawnow
end

end
