function [X,Y] = shadedErrorPrepCell(dataIn)

%Inputs: Cell containing N arrays of mx2 (or 2xm) series of data

%Output: one (N+1)x1000 array, where each dataset has been interpolated to
%a master x vector

%make sure that input arrays are oriented correctly (nx1)
for i = 1:length(dataIn)
    sz = size(dataIn{i});
    if sz(1)<sz(2)
        dataIn{i} = dataIn{i}';
    end
end

%find min, max X values
if length(dataIn)==1
    minX = min(dataIn{1}(:,1));
    maxX = max(dataIn{1}(:,1));
else
    minX = inf;
    maxX = -inf;
    for i = 1:length(dataIn)
        if min(dataIn{i}(:,1))<minX
            minX = min(dataIn{i}(:,1));
        end
        if max(dataIn{i}(:,1))>maxX
            maxX = max(dataIn{i}(:,1));
        end
    end
end

%create master X vector
X = linspace(minX,maxX,10000);

%build up Y array
Y = [];
for i = 1:length(dataIn)
    [~,ui] = unique(dataIn{i}(:,1));
    Y = [Y; interp1(dataIn{i}(ui,1),dataIn{i}(ui,2),X)];
end

%concatentate
% D = [X;Y];


end