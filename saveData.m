function saveData(data,fullPath,grid,expt,sweepNum)

fprintf(['Saving data']);

fullPath = regexprep(fullPath,'%E',num2str(expt.exptNum));
fullPath = regexprep(fullPath,'%P',['P' num2str(expt.penetrationNum,'%02d')]);
fullPath = regexprep(fullPath,'%N',num2str(grid.name));
fullPath = regexprep(fullPath,'%S',num2str(sweepNum));

% create directory hierarchy if necessary
f = find(fullPath=='\');
dirname = fullPath(1:f(end));

if ~exist(dirname,'dir')
    mkdir(dirname);
end

f = findstr('%C',fullPath);

for chan = 1:length(data)
    fprintf('.');
    filename = [fullPath(1:f-1) num2str(chan,'%02d') fullPath(f+2:end)];
    h = fopen(filename,'w');
    fwrite(h,data{chan},'float32');
    fclose(h);
    pause(0.01);
end

fprintf(['done after ' num2str(toc) ' sec.\n']);
