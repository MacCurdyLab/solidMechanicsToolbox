function [S0] = computeHyperElasticResponse(s,model,varargin)

%Lawrence Smith | lasm4254@colorado.edu

%this function numerically computes the viscoelastic response for discrete
%time-strain data using some number of Prony terms and the coefficients
%required to specify an elastic constitutive model.

%INPUTS:
%s      [nx1]:  discrete engineering strain vector, material must start at
%               strain. if s(1)=1, s is interpreted as stretch vector


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

end