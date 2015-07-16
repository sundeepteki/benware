function clusters = getkwikspikes_multishank(kwikfile, shankIdx, allWaveforms, unsortedSpikes)
% function clusters = getkwikspikes(kwikfile, shankIdx, allWaveforms, unsortedSpikes)
% 
% load spikes from a single shank of a multishank .kwik file, combine with
% data from benware to get spike times on each
% sweep

which_clustering = 'main';
if exist('unsortedSpikes') && unsortedSpikes
  which_clustering = 'original';
end

if ~exist('allWaveforms', 'var')
  allWaveforms = false;
end

re = regexp(kwikfile, '(.*)/.*', 'tokens');
exptdir = re{1}{1};

% get info about sample rate
l = load([exptdir filesep 'gridInfo.mat']);
f_s = l.expt.dataDeviceSampleRate;

% kwikfile shanks start at 0
shankGroup = sprintf('/channel_groups/%d/', shankIdx-1);

% get info about sweep lengths
l = load([exptdir filesep 'sweep_info.mat']);
sweepLens = l.sweepLens;

% get spike times and convert to sweeps
spikeTimes = h5read(kwikfile, [shankGroup 'spikes/time_samples']);
spikeTimes = spikesamples2sweeptimes(f_s, spikeTimes, sweepLens);

% get waveform data from .kwx file
kwxfile = [kwikfile(1:end-4) 'kwx'];

waveform_data = h5read(kwxfile, [shankGroup '/waveforms_raw']);
[n_channels, n_channels, n_spikes] = size(waveform_data);
assert(n_spikes==size(spikeTimes, 1));

% get cluster assignments
clusterID = h5read(kwikfile, [shankGroup 'spikes/clusters/' which_clustering]);
n_clusters = max(clusterID);

% loop through clusters
clusters = {};
for cluster_idx = 1:n_clusters
  cluster = struct;
  cluster.clusterID = cluster_idx;
  clusterGroup = h5readatt(kwikfile, ...
    [shankGroup 'clusters/' which_clustering '/' num2str(cluster_idx)], 'cluster_group');
  if strcmp(which_clustering, 'original')
    assert(clusterGroup==3);
    cluster.clusterType = 'Unsorted';
  else
    cluster.clusterType = h5readatt(kwikfile, ...
      [shankGroup 'cluster_groups/' which_clustering '/' num2str(clusterGroup)], 'name');
  end
  times = spikeTimes(clusterID==cluster.clusterID,:);
  cluster.nSpikes = length(times);
  cluster.spikeTimes = times;

  waveforms = double(waveform_data(:,:,clusterID==cluster.clusterID));
  if allWaveforms
    cluster.waveforms = waveforms;
  else
    randidx = randperm(cluster.nSpikes);
    cluster.waveforms = waveforms(:,:,randidx(1:min(1000,cluster.nSpikes)));
  end

  % find which channel signal is biggest on
  cluster.meanWaveform = mean(waveforms, 3);
  cluster.channelSD = std(cluster.meanWaveform, [], 2)';
  cluster.peakChannel = find(cluster.channelSD==max(cluster.channelSD), 1);

  clusters{cluster_idx} = cluster;
  
end
clusters = [clusters{:}];

clear cluster; 

if length(clusters)==0
  return;
end

% merge MUA only if this is a single site probe
if n_channels==1
  mergeMUA = true;
else
  mergeMUA = false;
end

muaClusterIdx = find(strcmp({clusters(:).clusterType}, 'MUA'));
if mergeMUA && ~isempty(muaClusterIdx)
  % merge all MUA clusters into one
  suClusterIdx = setdiff(1:length(clusters), muaClusterIdx);

  newClusters = clusters(suClusterIdx);

  muaCluster = struct;
  muaCluster.clusterID = [clusters(muaClusterIdx).clusterID];
  %muaCluster.clusterGroup = [clusters(muaClusterIdx).clusterGroup];
  muaCluster.clusterType = 'MUA';
  times = cat(1, clusters(muaClusterIdx).spikeTimes);
  muaCluster.nSpikes = length(times);
  muaCluster.spikeTimes = times;

  waveforms = cat(3, clusters(muaClusterIdx).waveforms);
  if allWaveforms
    muaCluster.waveforms = waveforms;
  else
    randidx = randperm(muaCluster.nSpikes);
    muaCluster.waveforms = waveforms(:,:,randidx(1:min(1000,muaCluster.nSpikes)));
  end
  
  muaCluster.meanWaveform = mean(cat(3,clusters(:).meanWaveform),3);
  muaCluster.channelSD = std(muaCluster.meanWaveform, [], 2)';
  muaCluster.peakChannel = find(muaCluster.channelSD==max(muaCluster.channelSD), 1);
  
  newClusters(end+1) = muaCluster;
  
  clusters = newClusters;
end
