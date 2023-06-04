function S = OgdenNP(L,mu,alpha)

%Performs a calculation of Engineering Stress for an N-order Ogden
%hyperelastic solid under uniaxial tension with a stretch ratio L/L0 equal
%to Lambda

%L: nx1 vector of Stretch Ratio
%mu: mx1 vector of Ogden mu coefficients
%alpha: mx1 vector of Ogden alpha coefficients

S = zeros(size(L));

for i = 1:length(mu)
    
    S = S + mu(i)*(L.^(alpha(i)) - L.^-(0.5*alpha(i)));

end

end