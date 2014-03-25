function clusterData = getClusteredSpikes(dir, shank)

spikedetektDirs = getdirsmatching([dir filesep 'spikedetekt_*/']);
spikedetektDir = spikedetektDirs{end};

try
  files = getfilesmatching([spikedetektDir '*.fet.' num2str(shank)]);
catch
  error('FET file not found for shank %d\n', shank);
end

% fet file contains features and spike times
assert(length(files)==1);
fetfile = files{1};
fet = fetload(fetfile);
spikeTimes = fet(:,end); % in samples

% clu file contains cluster IDs
clufile = regexprep(fetfile, '.fet.', '.clu.');
clusterID = cluread(clufile);
nClusters = max(clusterID);

% they should contain one entry per spike each
assert(length(spikeTimes)==length(clusterID));

% get info about sample rate
l = load([dir filesep 'gridInfo.mat']);
f_s = l.expt.dataDeviceSampleRate;

% get info about sweep lengths
l = load([dir filesep 'spikedetekt' filesep 'sweep_info.mat']);
sweepLens = l.sweepLens;

% biggest spike time should be less than biggest sample
assert(max(spikeTimes)<sum(sweepLens));

% convert spike times to sweep times
sweepEdges = [0 cumsum(sweepLens)];
sweepStarts = sweepEdges(1:end-1);
sweepEnds = sweepEdges(2:end);

nSpikes = length(spikeTimes);
sweepTimes = nan(nSpikes, 2);
for ii = 1:nSpikes
  sweepTimes(ii, 1) = find(spikeTimes(ii)>=sweepStarts & spikeTimes(ii)<sweepEnds);
  sweepTimes(ii, 2) = (spikeTimes(ii)-sweepStarts(sweepTimes(ii, 1)))/f_s;
end

% separate by cluster
clusterData = {};

for cc = 0:nClusters
  data = struct;
  data.clusterID = cc;
  times = {};
  for ss = 1:length(sweepStarts)
    f = find(sweepTimes(:,1)==ss & clusterID==cc)
    times{ss} = spikeTimes(f);
  end
  data.spikeTimes = times;
  clusterData{end+1} = data;
end

clusterData = [clusterData{:}];

