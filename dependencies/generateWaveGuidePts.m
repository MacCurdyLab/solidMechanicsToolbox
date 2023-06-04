function [V] = generateWaveGuidePts(bunch_factor,arc_radius,entry_radius,num_arcs,radoff,ptspc)

% bunch_factor  = 0.75;    %must be between -1 and 1 (interference @ ~0.85)
% arc_radius    = 10;     %mm
% entry_radius  = 5;      %mm
% num_arcs      = 2;

h_center = arc_radius*bunch_factor;

X = [];
Y = [];
offset = 0;
offset_inc = 2*sqrt(arc_radius^2-h_center^2);

%determine angles for start and end of arc (used non-terminal arcs)
start_theta = pi+asin(h_center/arc_radius);
end_theta = 0-asin(h_center/arc_radius);

sweptLength = abs(start_theta-end_theta)*arc_radius;
n_segments = ceil(sweptLength/ptspc);

theta = linspace(start_theta,end_theta,n_segments);

%add on tangency segments
tcrit = asin((entry_radius-h_center)/(entry_radius+arc_radius));
x_0 = -sqrt((entry_radius+arc_radius)^2 - (entry_radius-h_center)^2);


for i = 1:num_arcs
    
    %if we are on the first arc, add the entry segment
    if i==1 
        %entry segment
        theta1 = linspace(-pi/2,-tcrit,ceil(n_segments/4.5));
        X = [X (entry_radius-radoff)*cos(theta1)+x_0];
        Y = [Y (entry_radius-radoff)*sin(theta1)+entry_radius];

        %partial normal segment
        theta2 = linspace(pi-tcrit,end_theta,n_segments);
        X = [X (arc_radius+radoff)*cos(theta2(2:end))];
        Y = [Y h_center+(arc_radius+radoff)*sin(theta2(2:end))];
    else
        %full normal segment
        X = [X (arc_radius+radoff)*cos(theta(2:end))+offset];
        Y = [Y h_center+(arc_radius+radoff)*sin(theta(2:end))];
    end
    offset = offset + offset_inc;

    %if we are on the last arc, add the exit segment
    if i==num_arcs
        %partial normal segment
        theta2 = linspace(start_theta,tcrit,n_segments);
        X = [X (arc_radius-radoff)*cos(theta2(2:end))+offset];
        Y = [Y -h_center-(arc_radius-radoff)*sin(theta2(2:end))];

        %exit segment
        theta1 = linspace(pi-tcrit,pi/2,ceil(n_segments/4.5));
        X = [X (entry_radius+radoff)*cos(theta1(2:end))-x_0+offset];
        Y = [Y (entry_radius+radoff)*sin(theta1(2:end))-entry_radius];
    else
        %normal segment
        X = [X (arc_radius-radoff)*cos(theta(2:end))+offset];
        Y = [Y -h_center-(arc_radius-radoff)*sin(theta(2:end))];
    end
    offset = offset + offset_inc;
end

V = [X' Y'];

%now let's space the points according to desired point spacing
%requires an install of "GibbonCode" https://www.gibboncode.org/
%[V]=evenlySpaceCurve(V,segment_length,'linear');

% 
end

