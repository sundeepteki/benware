function [paramsFile, nSitesPerShank] = benware2spikedetekt2(dataDir)
% benware2spikedetekt2
% this is for new-style benware data, using interleaved files

% put all data in a single file
singleFile = true;

if ispc
  filesep = '\\'; % yet another Matlab WTF... :/ - needed avoid invalid escape sequences in sprintf
else
  filesep = '/';
end

if ~exist(dataDir, 'dir')
  error('Directory %s does not exist\n', dataDir);
end

if ~exist([dataDir filesep 'gridInfo.mat'], 'file')
  error('%s is not a benware data directory\n', dataDir);
end

fprintf('Converting %s...\n', dataDir);
l = load([dataDir filesep 'gridInfo.mat']);
nChannels = length(l.expt.channelMapping);

gridName = l.grid.name;
dataPath = [dataDir filesep l.expt.dataFilename];

% get multiplier for int16 format
fprintf('Getting range of data\n');
sweepIdx = 1;
maxabs = -Inf;
while exist(constructDataPath(dataPath, l.grid, l.expt, sweepIdx, nChannels))
  tmp = f32read(constructDataPath(dataPath, l.grid, l.expt, sweepIdx, nan));
  maxabs = max(maxabs, max(abs(tmp(:))));

  fprintf('.');
  if round(sweepIdx/70)==(sweepIdx/70)
    fprintf('\n');
  end

  sweepIdx = sweepIdx+1;
end
mult = 32767/maxabs/2; % seems to be needed to prevent clipping
fprintf('done\n');

fprintf('Converting sweeps to spikedetekt format\n');

sweepLens = [];
sweepIdx = 1;

shortFilename = [gridName '.sweeps.i16.dat'];
filename = [dataDir filesep shortFilename];

while exist(constructDataPath(dataPath, l.grid, l.expt, sweepIdx, nan))
  fprintf('.');
  if round(sweepIdx/70)==(sweepIdx/70)
    fprintf('\n');
  end
  
  sweepData = f32read(constructDataPath(dataPath, l.grid, l.expt, sweepIdx, nan));
  assert(mod(length(sweepData)/nChannels,1)==0)
  sweepLens(end+1) = length(sweepData)/nChannels;

  if sweepIdx==1
    int16write(sweepData, filename, mult);
  else
    % append
    int16write(sweepData, filename, mult, true);
  end

  sweepIdx = sweepIdx+1;

end

nFiles = 1; % number of data files

fprintf(' done\n');

[paramsFile, probeFile, nSitesPerShank] = makeklustaparams(l.expt, l.grid, dataDir, shortFilename);

datafile = shortFilename;
save([dataDir filesep 'sweep_info.mat'], 'datafile', 'sweepLens', 'paramsFile', 'probeFile', 'nSitesPerShank');
