%% Extract Spline Region Data
%Lawrence Smith | lasm4254@colorado.edu | April 2021

%% Fetch Plot to Extract From and Display
imName = uigetfile({'*.png';'*.jpg';'*.jpeg';'*.tif';'*.bmp'});
img = imread(imName);
imshow(img);

%% Extract Axes
title('CLICK ON PLOT ORIGIN','Color','r','FontSize',18)
origin = ginput(1);     sound(1);
x1 = str2double(inputdlg('Enter X Min:','Xlim(1)', [1 40]));
y1 = str2double(inputdlg('Enter Y Min:','Ylim(1)', [1 40]));

title('CLICK ON X Max','Color','r','FontSize',18)
xmax   = ginput(1);     sound(1);
x2 = str2double(inputdlg('Enter X Max:','Xlim(2)', [1 40]));

if strcmp(inputdlg('Logrithmic Axis? y = yes; n = no','', [1 40]),'y')
    islogx = true;
else
    islogx = false;
end

title('CLICK ON Y Max','Color','r','FontSize',18)
ymax   = ginput(1);     sound(1);

y2 = str2double(inputdlg('Enter Y Max:','Ylim(2)', [1 40]));
if strcmp(inputdlg('Logrithmic Axis? y = yes; n = no','', [1 40]),'y')
    islogy = true;
else
    islogy = false;
end

% extract scaling
if islogx
    ax_x = [log10(x1) log10(x2)];
else
    ax_x = [x1 x2];
end

if islogy
    ax_y = [log10(y1) log10(y2)];
else
    ax_y = [y1 y2];
end

title('TRACE A SPLINE - PRESS x TO CLOSE LOOP','Color','r','FontSize',18)

%% Extract Curves
curvelist = {}; exitLoop = 0; k=1; namelist = {};
while exitLoop == 0

    loop = drawLoop();

    X = interp1([origin(1) xmax(1)],ax_x,loop(1,:));
    Y = interp1([origin(2) ymax(2)],ax_y,loop(2,:));

    %saturate
    X(loop(1,:)<origin(1))=ax_x(1);
    X(loop(1,:)>xmax(1))=ax_x(2);
    Y(loop(2,:)>origin(2))=ax_y(1);
    Y(loop(2,:)<ymax(2))=ax_y(2);

    pgon=polyshape(X(1:end-1),Y(1:end-1));
    [xC,yC]=centroid(pgon);
    
    if islogx
        X = 10.^X;
        xC= 10.^xC;
    end
    if islogy
        Y = 10.^Y;
        yC= 10.^yC;
    end

    curvelist{k} = [X;Y];
    labelPos{k} = [xC,yC];

    namelist{k} = inputdlg('Enter Nametag for Data','', [1 40]);
    answer = inputdlg('Draw another? y = yes; n = no','', [1 40]);
    k = k+1;
    if strcmp(answer,'n')
        exitLoop = 1;  
    end
end

splineData.curvelist = curvelist;
splineData.namelist = namelist;
splineData.labelPos = labelPos;
splineData.islogx = islogx;
splineData.islogy = islogy;

%% Save Out the Data
DataName = inputdlg('Enter Nametag for Entire DataSet','', [1 40]);
save(DataName{1},'splineData')

%% Regenerate Plot
close all
splineRegionPlot(splineData)

%% Support Functions
function [points] = drawLoop()

[px1, py1] = ginput(1);
hold on
ExitLoop = 0;

allx = [];
ally = [];
h = [];
while ExitLoop == 0
    [x, y] = ginput(1);
    u = findall(gca,'type','line');
    if size(u,1)>0
        delete(u(1))
    end
    allx = [allx; x];
    ally = [ally; y];
    fnplt( cscvn( [px1 py1; allx, ally;].' ),'r');
    if strcmp(get(gcf,'currentcharacter'),'x')
        ExitLoop = 1;
        set(gcf,'currentcharacter','y');
    end
end
spcv = cscvn( [px1 py1; allx(1:end-1), ally(1:end-1); px1 py1;].' );

u = findall(gca,'type','line');
if size(u,1)>0
    delete(u(1))
end
fnplt(spcv,'b');
points = fnplt(spcv);
delete(h)
hold off 

end