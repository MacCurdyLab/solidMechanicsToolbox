function [Ui] = interpDisp(T,U,t)

%Lawrence Smith | lasm4254@colorado.edu

%return displacement field interpolated at desired timestep vector t, from
%original displacement data U (n x 3 x m) and time vector T (m x 1)

% Turn the 3D displacement array into a 2D array, where each row is a
% timestep and each column is a displacement DOF

dim = size(U,2);

Um = transpose(reshape(U,[],size(U,3)));

% Form gridded interpolation operator
int_op = griddedInterpolant(T,Um);

% interpolate
Ui = int_op(t);

% Reshape back into 3D array
Ui = reshape(Ui',size(U,1),dim,[]);

end