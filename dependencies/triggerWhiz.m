function [Si] = triggerWhiz(S,varargin)

%Lawrence Smith | lasm4254@colorado.edu
%Feb 2023

% a handy funciton for interactive triggering of a discrete time signal

%Mandatory Inputs: 
% S - [nx1] vector; signal
%Optional Inputs:
% filterSize - scalar giving the window for a zero phase moving average
% filter applied to the data if the f key is pressed

if length(varargin)>0
    plotTitle = varargin{1};
end

%Outputs: Si - scalar integer value; the index of the trigger

%force S into a column format (in case it came in as a row)
S = S(:);
filtSize = 15;
% dS = gradient(S);
% filtSize = 15;
% fS = filtfilt(ones(filtSize, 1)/filtSize, 1,S);

bad = true;

while bad

%open up a figure, and make it nice and large (more room to see the signal)
f = figure("Position",[125 25 1150 700]);

%plot the signal
s = plot(S,'k-','linewidth',1,'markersize',5);
Sold = S;
Lold = axis;
hold on

Instructions = ['Rclick = Set Trigger at Cursor  ',...
                        'Enter = Accept Placement  '];


%                         'Rclick = dilate time axis  ',...
%                         'dKey = apply derivative  ', ...
%                         'fKey = apply filter  ', ...
%                         'sKey = start over' ;
%                         '0Key = null result];

zoomScale = [0.25 1.0];

Si = [];
plotSi = false;

title(Instructions)
% title(plotTitle)

[clicX, clicY, clicButton] = zoomginput(1);
    while ~isempty(clicButton)      % ENTER to quit
      switch clicButton

        case 1     % Left click
          %compute cartesian distance from click point to all signal points
          D = sqrt(sum(([1:length(S);S'] - [clicX; clicY]).^2,1));
          %Find the index of the signal point closest to the click
          [~,Si] = min(D);
          plotSi=true;

        case 3     % Right click
          %query the current axis limits
          L = reshape(axis,2,2);
          mL = mean(L);
          %compute the ranges of the axes limits
          R = zoomScale.*0.5.*diff(L);
          %now set the axis limits
%           axis([clicX-R(1) clicX+R(1) clicY-R(2) clicY+R(2)])
         axis([clicX-R(1) clicX+R(1) mL(2)-R(2) mL(2)+R(2)])
         case 100 % dKey
                delete(s)
              S = gradient(S);
              s = plot(S,'k-','linewidth',1,'markersize',5);
              axis auto

         case 102 % fKey
              delete(s)
              S = filtfilt(ones(filtSize, 1)/filtSize, 1,S);
              s = plot(S,'k-','linewidth',1,'markersize',5);

         case 115 % sKey
              delete(s)
              S = Sold;
              s = plot(S,'k-','linewidth',1,'markersize',5);
              plotSi = false;
              axis(Lold)
         case 48 % 0Key
              close(f)
              Si = NaN;
              return   
      end
      if exist('p')
        delete(p)
      end
      if plotSi
        p = plot(Si,S(Si),'r.','markersize',30);
      end
      [clicX, clicY, clicButton] = zoomginput(1);
    end


if isempty(Si)
    disp('No trigger was selected!')
else
    p = plot(Si,S(Si),'b.','markersize',35);
    bad = false;
    pause(1)
end
close(f)
end


end