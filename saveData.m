function saveData(data,grid,expt,sweepNum)

fprintf(['Saving data']);

fullPath = constructDataPath([grid.dataDir grid.dataFilename],grid,expt,sweepNum);

f = find(fullPath,'\');
dirName = fullPath(1:f(end));
if ~exist(dirName,'dir');
    mkdir(dirName);
end

f = findstr('%C',fullPath);

for chan = 1:length(data)
    fprintf('.');
    filename = [fullPath(1:f-1) num2str(chan,'%02d') fullPath(f+2:end)];
    h = fopen(filename,'w');
    fwrite(h,data{chan},'float32');
    fclose(h);
end

fprintf(['done after ' num2str(toc) ' sec.\n']);
