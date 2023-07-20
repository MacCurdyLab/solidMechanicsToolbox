function [S] = computeViscoElasticResponse(t,s,g,tau,model,varargin)

%Lawrence Smith | lasm4254@colorado.edu

%this function numerically computes the viscoelastic response for discrete
%time-strain data using some number of Prony terms and the coefficients
%required to specify an elastic constitutive model.

%INPUTS:
%t      [nx1]:  discrete time vector
%s      [nx1]:  discrete engineering strain vector, material must start at
%               strain. if s(1)=1, s is interpreted as stretch vector
%g      [px1]:  vector containing p Prony scaling terms
%tau    [px1]:  vector containing tau Prony time constants. if g contains 
%               an extra term, the first term is assumed to be ginf

%model [string] defines elastic constitutive model and format of varargin
% 'LE'  - Linear Elasticity model. varargin must contain Young's modulus
% 'NH'  - NeoHookean model. varargin must contain shear modulus mu (2nd Lame)
% 'OG'  - Ogden Hyperelasticity model. varargin must contain two vectors:
    %       mu      [mx1]:  vector of Ogden elastic coefficients
    %       alpha   [mx1]:  vector of Ogden shape coefficients

if s(1) == 1
    s = s-1;
end

try
if strcmp(model,'LE')
    E0 = varargin{1};
    S0 = E0*s;
elseif strcmp(model,'NH')
    mu = varargin{1};
    S0 = neoHookeanE(mu,s+1);
elseif strcmp(model,'OG')
    mu = varargin{1};
    alpha = varargin{2};
    S0 = OgdenNP(s+1,mu,alpha);
else
    fprintf('\n\n ERROR: INCORRECT FUNCTION INPUTS')
    return
end
catch
fprintf('\n\n ERROR: INCORRECT FUNCTION INPUTS')
return
end

%determine g coefficients
if length(g)==length(tau)
    ginf = 1-sum(g);
else
    ginf = g(1);
    g(1) = [];
end


S = S0(1);
dS0dt = gradient(S0,t);

for n = 2:length(t)
    
dt = t(n)-t(n-1);

for i = 1:length(g)

if n>2
%Equation 5 of Goh 2014
hi = trapz(t(1:n-1),g(i)*exp(-(t(n-1)-t(1:n-1))/tau(i)).*dS0dt(1:n-1));
else
hi=0;
end

%store this Prony Term as another Sn entry
Sn(i) =  exp(-dt/tau(i))*hi+g(i)*(1-exp(-dt/tau(i)))/(dt/tau(i))*(S0(n)-S0(n-1));
end

%Equation 12 of Goh 2014
Sr = ginf*S0(n)+sum(Sn);

%append this stress to the stress vector
S=[S; Sr];

end

end