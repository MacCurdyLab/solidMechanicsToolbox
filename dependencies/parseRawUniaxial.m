function [stretch, stress, data] = parseRawUniaxial(csvFiles)

% INPUT: csvFiles = {'name1.csv', 'name2.csv', ...}
% Parses raw tensile test CSVs with columns: Time (sec), Position (mm), Load (N) -> Stretch, True Stress (MPa)

% DOGBONE INFO
L0 = 33; % mm
Width = 6.0;
Thickness = 1.5;
A0 = Width * Thickness;
saveFile = true;
Plot = true;

nFiles = numel(csvFiles);
allStretch = cell(nFiles,1);
allStress  = cell(nFiles,1);

% read in data and process
for iFile = 1:nFiles
    csvFile = csvFiles{iFile};
    M = readmatrix(csvFile);
    M = M(all(~isnan(M),2),:);
    t = M(:,1);
    pos = M(:,2); % mm
    load = M(:,3); % N
    if any(load < -1)
        load = load .* (-1); % flip sign
    end

    % trim to the loading pull (cut out slack)
    loadTol = 0.01 * max(load);
    iStart = find(load > loadTol, 1, 'first');
    pos = pos(iStart:end);
    load = load(iStart:end);

    % also cut off failure points (where load drops)
    deltaLoad = [0; diff(load)];
    iFailure = find(deltaLoad < -0.2, 1, 'first');
    if ~isempty(iFailure)
        pos = pos(1:iFailure-1);
        load = load(1:iFailure-1);
    end

    % convert to stretch and engineering stress
    stretch = (L0 + pos) / L0; % L / L0
    stress = (load / A0) .* stretch; % N/mm^2 = MPa

    % take out duplicates
    [stretch, uIdx] = unique(stretch, 'stable');
    stress = stress(uIdx);

    allStretch{iFile} = stretch(:);
    allStress{iFile}  = stress(:);
end

% get mean where data overlaps
nGrid = 40;
sMin = max(cellfun(@(x) x(1), allStretch));
sMax = min(cellfun(@(x) x(end), allStretch));
stretchGrid = linspace(sMin, sMax, nGrid)';

stressMatrix = zeros(nGrid, nFiles);
for fi = 1:nFiles
    stressMatrix(:,fi) = interp1(allStretch{fi}, allStress{fi}, stretchGrid, 'linear');
end

stretch = stretchGrid;
stress = mean(stressMatrix, 2);

% write and plot
stretch = stretch(:); stress = stress(:);
data = [1 0; stretch(2:end) stress(2:end)]; % force first row to 1 0

if saveFile
    [folder, name, ~] = fileparts(csvFile);
    outfile = fullfile(folder, [name(1:end-1) '.txt']);
    writematrix(data, outfile);
    fprintf('Wrote %d points to %s\n', size(data,1), outfile);
end

if Plot
    figure('Name','parseRawUniaxial');
    subplot(2,1,1);
    colors = lines(nFiles);
    yyaxis left
    hold on
    for fi = 1:nFiles
        M = readmatrix(csvFiles{fi});
        M = M(all(~isnan(M),2),:);
        [~, fname, ~] = fileparts(csvFiles{fi});
        plot(M(:,1), M(:,2), 'Color', [colors(fi,:)], 'DisplayName', [fname ' pos'], 'Marker', 'none', 'LineStyle', '-');
    end
    ylabel('Position [mm]')

    yyaxis right
    hold on
    for fi = 1:nFiles
        M = readmatrix(csvFiles{fi});
        M = M(all(~isnan(M),2),:);
        [~, fname, ~] = fileparts(csvFiles{fi});
        plot(M(:,1), M(:,3), 'Color', [colors(fi,:)], 'DisplayName', [fname ' load'], 'Marker', 'none', 'LineStyle', '-');
    end
    ylabel('Load [N]')

    xlabel('Time [s]')
    title('Raw position and load vs time'); grid on
    legend('Location','northwest');

    subplot(2,1,2); hold on
    for fi = 1:nFiles
        [~, fname, ~] = fileparts(csvFiles{fi});
        plot(allStretch{fi}, allStress{fi}, 'Color', [0.7 0.7 0.7], 'DisplayName', [fname]);
    end
    plot(stretch, stress, 'r-', 'LineWidth', 2, 'DisplayName','mean');
    xlabel('Stretch \lambda'); ylabel('True Stress [MPa]')
    title(sprintf('Processed (A_0=%.2f mm^2, L_0=%.1f mm)', A0, L0))
    grid on; legend; set(gcf,'Color','w')
end

end
