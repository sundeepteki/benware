function benware_old2new(dataDir)

l = load([dataDir filesep 'gridInfo.mat']);

nChannels = length(l.expt.channelMapping);

gridName = l.grid.name;
oldDataPath = [dataDir filesep l.expt.dataFilename];

newDataFilename = regexprep(l.expt.dataFilename,'raw.f32[\\\/]','');
newDataFilename = regexprep(newDataFilename,'.channel.%C','');
%newDataFilename = regexprep(newDataFilename,'.sweep.%S.channel.%C','');
newDataFilename = [newDataFilename '.dat'];
newDataPath = [dataDir filesep newDataFilename];

sweepIdx = 1;

fprintf('Converting data to interleaved format')
while exist(constructDataPath(oldDataPath, l.grid, l.expt, sweepIdx, nChannels))
  data = [];
  for chanIdx = 1:nChannels
    data(chanIdx,:) = f32read(constructDataPath(oldDataPath, l.grid, l.expt, sweepIdx, chanIdx));
  end
  filename = constructDataPath(newDataPath, l.grid, l.expt, sweepIdx, 0);
  h = fopen(filename, 'w');
  fwrite(h, data, 'float32');
  fclose(h);
  sweepIdx = sweepIdx + 1;
  fprintf('.');
end
fprintf('done\n');

movefile([dataDir filesep 'gridInfo.mat'], [dataDir filesep 'gridInfoOrig.mat']);
grid = l.grid;
expt = l.expt;
expt_orig = l.expt;
expt.dataFilename = newDataFilename;
save([dataDir filesep 'gridInfo.mat'], 'expt', 'grid', 'expt_orig');

% no longer needed -- klustaparams is made by benware2spikedetekt2
%l.expt.dataDir = dataDir;
%l.expt.dataFilename = newDataFilename;
%makeklustaparams(l.expt, l.grid);
