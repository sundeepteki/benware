function [paramsFile, nSitesPerShank] = benware2spikedetekt(dataDir)

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
  for chanIdx = 1:nChannels
    tmp = f32read(constructDataPath(dataPath, l.grid, l.expt, sweepIdx, chanIdx));
    maxabs = max(maxabs, max(abs(tmp(:))));
  end

  fprintf('.');
  if round(sweepIdx/70)==(sweepIdx/70)
    fprintf('\n');
  end

  sweepIdx = sweepIdx+1;
end
mult = 32767/maxabs;
fprintf('done\n');

newDir = [dataDir filesep 'spikedetekt'];
mkdir_nowarning(newDir);
fprintf('Converting sweeps to spikedetekt format\n');
filenames = {};
sweepLens = [];

sweepIdx = 1;

filename = [newDir filesep gridName '.sweeps.dat'];
shortFilename = [gridName '.sweeps.dat'];

while exist(constructDataPath(dataPath, l.grid, l.expt, sweepIdx, nChannels))
  fprintf('.');
  if round(sweepIdx/70)==(sweepIdx/70)
    fprintf('\n');
  end
  
  % load all data for this sweep
  sweepData = [];
  for chanIdx = 1:nChannels
    d = f32read(constructDataPath(dataPath, l.grid, l.expt, sweepIdx, chanIdx));
    try
      sweepData(:,chanIdx) = d;
    catch
      error('Data for sweep %d, channel %d is not the same size as previous channels', sweepIdx, chanIdx);
    end
  end
  
  sweepLens(end+1) = size(sweepData, 1);
  
  % interleave data
  sweepData = sweepData';
  sweepData = sweepData(:);
  
  % open output data file for this sweep
  if sweepIdx==1
    int16write(sweepData, filename, mult);
  else
    % append
    int16write(sweepData, filename, mult, true);
  end

  sweepIdx = sweepIdx+1;

end

filenames = {shortFilename};
nFiles = 1; % number of data files

fprintf(' done\n');

fprintf('Making spikedetekt parameter file...');
paramsFile = [gridName '.params'];
fid = fopen([newDir filesep paramsFile], 'w');
fprintf(fid, 'RAW_DATA_FILES = [');
for sweepIdx = 1:nFiles
  fprintf(fid, ['''' filenames{sweepIdx} '''' ', ']);
end
fprintf(fid, ']\n');

fprintf(fid, 'SAMPLERATE = %0.6f\n', l.expt.dataDeviceSampleRate);
fprintf(fid, 'NCHANNELS = %d\n', nChannels);
fprintf(fid, 'PROBE_FILE = ''%s''\n', [gridName '.probe']);
fprintf(fid, 'VOLTAGE_RANGE = %0.6f\n', 32767/mult);
fprintf(fid, 'USE_SINGLE_THRESHOLD = False\n');

spikeDetektDev = true; % true if using spikedetekt amalgamated_dev branch
if spikeDetektDev
  fprintf(fid, 'WRITE_FIL_FILE = False\n');
  fprintf(fid, 'WRITE_BINFIL_FILE = False\n');
  fprintf(fid, 'THRESH_SD = 4.5\n');
  fprintf(fid, 'THRESH_SD_LOWER = 2\n');
  fprintf(fid, 'USE_OLD_CC_CODE = True\n');
  fprintf(fid, 'AMPLITUDE_WEIGHT = False\n');
  fprintf(fid, 'WEIGHT_POWER = 1\n');
  fprintf(fid, 'USE_HILBERT = False\n');
  fprintf(fid, 'USE_COMPONENT_ALIGNFLOATMASK = True\n');
  fprintf(fid, 'DEBUG = False\n');
end

%mult
%fprintf(fid, 'ADDITIONAL_FLOAT_PENUMBRA = 0\n');
%fprintf(fid, 'DTYPE = ''f32''');
%fprintf(fid, 'CHUNK_SIZE = 30000\n');
%fprintf(fid, 'CHUNK_OVERLAP_SECONDS = 0.1\n');
%fprintf(fid, 'DEBUG = True\n');

fclose(fid);
fprintf('done\n');

fprintf('Making probe adjacency map...');
probes = l.expt.probes;
layout = {};

for ii = 1:length(probes)
  if strcmp(probes(ii).layout, 'Warp-16')
    layout{ii} = [16 1];

  elseif probes(ii).layout(1)=='A'
    res = regexp(probes(ii).layout, 'A([0-9]+)x([0-9]+)', 'tokens');
    nShanks = eval(res{1}{1});
    nSites = eval(res{1}{2});
    layout{ii} = [nShanks nSites];

  else
    error('unknown probe layout -- talk to ben');
  end
end

makeadjacencygraph(layout, [newDir filesep gridName '.probe']);

nSitesPerShank = [];
for ii = 1:length(layout)
  nSitesPerShank = [nSitesPerShank repmat(layout{ii}(2), [1 layout{ii}(1)])];
end

save([newDir filesep 'sweep_info.mat'], 'filenames', 'sweepLens', 'paramsFile', 'nSitesPerShank');

fprintf('done\n');
