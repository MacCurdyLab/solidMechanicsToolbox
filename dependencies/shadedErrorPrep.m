function [X,Y] = shadedErrorPrep(varargin)

%Inputs: N arrays, each containing an mx2 (or 2xm) series of data

%Output: one (N+1)x1000 array, where each dataset has been interpolated to
%a master x vector

%make sure that input arrays are oriented correctly (nx1)
for i = 1:length(varargin)
    sz = size(varargin{i});
    if sz(1)<sz(2)
        varargin{i} = varargin{i}';
    end
end

%find min, max X values
if length(varargin)==1
    minX = min(varargin{1}(:,1));
    maxX = max(varargin{1}(:,1));
else
    minX = inf;
    maxX = -inf;
    for i = 1:length(varargin)
        if min(varargin{i}(:,1))<minX
            minX = min(varargin{i}(:,1));
        end
        if max(varargin{i}(:,1))>maxX
            maxX = max(varargin{i}(:,1));
        end
    end
end

%create master X vector
X = linspace(minX,maxX,1000);

%build up Y array
Y = [];
for i = 1:length(varargin)
    Y = [Y; interp1(varargin{i}(:,1),varargin{i}(:,2),X)];
end

%concatentate
% D = [X;Y];


end