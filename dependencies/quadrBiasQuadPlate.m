function [F,V] = quadrBiasQuadPlate(nEl,b1,b2,b3,b4)

%nEl - a 1x2 vector with number of elements in 

[x,y] = meshgrid(linspace(0,1,nEl(1)+1),linspace(0,1,nEl(2)+1));

e1 = quadrSpVec(nEl(1)+1,b1);
e2 = quadrSpVec(nEl(2)+1,b2);
e3 = quadrSpVec(nEl(1)+1,b3);
e4 = quadrSpVec(nEl(2)+1,b4);

[Xa,Ya] = meshgrid(linspace(0,1,nEl(1)+1),[0 1]);
X = interp2(Xa,Ya,[e1'; e3'],x,y);

[Xb,Yb] = meshgrid([0 1],linspace(0,1,nEl(2)+1));
Y = interp2(Xb,Yb,[e2 e4],x,y);

[F,~]=quadPlate([1 1],nEl);

V = [X(:),Y(:)];

end