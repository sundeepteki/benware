function saveData(data, grid, expt, sweepNum, nSamples)
% saveData(data, grid, expt, sweepNum)

fprintf(['  * Saving data\n']);

% ensure target directory exists
dirTemplate = [expt.dataDir expt.dataFilename];
fullPath = constructDataPath(dirTemplate, grid, expt, sweepNum);
dirName = split_path(fullPath);
mkdir_nowarning(dirName);

% save each channel in a separate f32 file
for chanNum = 1:size(data,1)
    fprintf('.');
    filename = constructDataPath(dirTemplate, grid, expt, sweepNum, chanNum);
    h = fopen(filename, 'w');
    fwrite(h, data(chanNum,1:nSamples), 'float32');
    fclose(h);
end

fprintf(['  * Done after ' num2str(toc) ' sec.\n']);
