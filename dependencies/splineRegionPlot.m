function [] = splineRegionPlot(splineData,varargin)
%TODO: we shouldn't pass all this shit in. we should just pass in the xy
%points to plot. do the scaling and saturation in the first file.


%splineData is a struct with the following fields:

%curvelist: 1xn cell where each index contains a set of XY points defining
%the boundary of a closed region.
%namelist: 1xn cell containing labels for the regions
%islogx: bool defining x axis scaling
%islogy: bool defining y axis scaling


if isempty(varargin)
    % clor = brewermap(12,'set1');
    clor = lines(12);
else
    clor = varargin{1};
end

for i = 1:size(splineData.curvelist,2)

    loop = splineData.curvelist{i};
    C = splineData.labelPos{i};

    patch(loop(1,:),loop(2,:),clor(i,:),'facealpha',0.2)
    text(C(1),C(2),splineData.namelist{i},'fontname','times new roman',...
        'FontSize',14,'Color',0.6*clor(i,:),'HorizontalAlignment','center',...
        'LineWidth',1.5,'VerticalAlignment','middle')
    hold on

end

if splineData.islogx
    set(gca,'xscale','log')
end
if splineData.islogy
    set(gca,'yscale','log')
end

end