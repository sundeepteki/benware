function saveData(data,basename,penNum,sweepNum)

fprintf(['Saving data']);

f = findstr('%P',basename);
basename = [basename(1:f-1) 'P' num2str(penNum,'%02d') basename(f+2:end)];
f = findstr('%S',basename);
basename = [basename(1:f-1) num2str(sweepNum) basename(f+2:end)];

% create directory hierarchy if necessary
f = find(basename=='\');
dirname = basename(1:f(end));

if ~exist(dirname,'dir')
    mkdir(dirname);
end

f = findstr('%C',basename);

for chan = 1:length(data)
    fprintf('.');
    filename = [basename(1:f-1) num2str(chan,'%02d') basename(f+2:end)];
    h = fopen(filename,'w');
    fwrite(h,data{chan},'float32');
    fclose(h);
    pause(0.01);
end

fprintf(['done after ' num2str(toc) ' sec.\n']);
