function S = YeohNP(L,C)

%Performs a calculation of Engineering Stress for an N-order Yeoh
%hyperelastic solid under uniaxial tension with a stretch ratio L/L0 equal
%to Lambda

%L: nx1 vector of Stretch Ratio
%C: mx1 vector of Yeoh coefficients

S = zeros(size(L));

for i = 1:length(C)

    S = S + 2*C(i)*i*(L - L.^-2).*(L.^2 + 2./L - 3).^(i-1);

end

end