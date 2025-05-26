function [S] = NeoHookeanE(L,mu)

%formula for engineering stress of an incompressible neohookean solid 
%in uniaxial tension
%https://en.wikipedia.org/wiki/Neo-Hookean_solid

S = mu*(L-1./(L.^2));
end

