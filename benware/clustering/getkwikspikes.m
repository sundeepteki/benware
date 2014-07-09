function clusters = getkwikspikes(kwikfile)
% function clusters = getkwikspikes(kwikfile)
% 
% load spikes from kwik file, combine with
% data from benware to get spike times on each
% sweep

re = regexp(kwikfile, '(.*)/.*/.*', 'tokens');
exptdir = re{1}{1};

% get info about sample rate
l = load([exptdir filesep 'gridInfo.mat']);
f_s = l.expt.dataDeviceSampleRate;

% get info about sweep lengths
l = load([exptdir filesep 'spikedetekt' filesep 'sweep_info.mat']);
sweepLens = l.sweepLens;

info = h5info(kwikfile);
shankGroup = find(strcmp({info.Groups.Name},'/shanks'));
shankid = info.Groups(shankGroup).Groups(1).Name;
re = regexp(shankid, '/shanks/shank([0-9]*)', 'tokens');
shanknum = str2num(re{1}{1});

% get spike times and convert to sweeps
shank_data = h5read(kwikfile, [shankid '/spikes']);
spikeTimes = spikesamples2sweeptimes(f_s, shank_data.time, sweepLens);

% get cluster assignments
clusterID = shank_data.cluster_manual;

% get cluster group assignments
cluster_data = h5read(kwikfile, [shankid '/clusters']);

% get meaning of cluster groups
group_data = h5read(kwikfile, [shankid '/groups_of_clusters']);
weirdnames = group_data.name';
group_names = {};
for jj = 1:size(weirdnames, 1)
  s = strsplit(weirdnames(jj,:), char(0));
  group_names{jj} = s{1};
end

% get waveform data
% can't find the right way to extract # samples from the kwik file,
% but it's in text form in there somewhere, so we'll assume its 38
% and check that the text '38' is present in the right place (grr)
waveform_nsamples = 38;
assert(strfind(info.Groups(1).Attributes(5).Value, '38')>0);

waveform_data = h5read(kwikfile, [shankid '/waveforms']);
n_samples = size(waveform_data.waveform_unfiltered,1);
n_channels = n_samples/waveform_nsamples;
assert(n_channels==floor(n_channels));

% make a structure with information about each cluster
clusters = {};
clusterIDs = unique(clusterID);
for ii = 1:length(clusterIDs)
  cluster = struct;
  cluster.clusterID = clusterIDs(ii);
  
  idx = cluster_data.cluster==cluster.clusterID;
  cluster.clusterGroup = cluster_data.group(idx);

  idx = group_data.group==cluster.clusterGroup;
  cluster.clusterType = group_names{idx};
  
  cluster.spikeTimes = spikeTimes(clusterID==cluster.clusterID,:);

  wf = double(waveform_data.waveform_filtered(:,clusterID==cluster.clusterID));
  n_spikes = size(wf, 2);
  wf = reshape(wf, n_channels,n_samples/n_channels,n_spikes);
  cluster.waveforms = wf;

  % find which channel signal is biggest on
  sd = std(reshape(wf, [n_channels, n_samples/n_channels*n_spikes]), [], 2);
  cluster.channelSD = sd;
  cluster.peakChannel = find(sd==max(sd),1);

  clusters{ii} = cluster;
  
end
clusters = [clusters{:}];

if length(clusters)==0
  return;
end

% merge MUA only if this is a single site probe
if n_channels==1
  mergeMUA = true;
else
  mergeMUA = false;
end
mergeMUA = true;

muaClusterIdx = find(strcmp({clusters(:).clusterType}, 'MUA'));
if mergeMUA && ~isempty(muaClusterIdx)
  % merge all MUA clusters into one
  suClusterIdx = setdiff(1:length(clusters), muaClusterIdx);

  newClusters = clusters(suClusterIdx);

  muaCluster = struct;
  muaCluster.clusterID = [clusters(muaClusterIdx).clusterID];
  muaCluster.clusterGroup = [clusters(muaClusterIdx).clusterGroup];
  muaCluster.clusterType = 'MUA';
  muaCluster.spikeTimes = cat(1, clusters(muaClusterIdx).spikeTimes);
  muaCluster.waveforms = cat(3, clusters(muaClusterIdx).waveforms);
  [n_c, n_s, n_sp] = size(muaCluster.waveforms);
  sd = std(reshape(muaCluster.waveforms, [n_c, n_s*n_sp]), [], 2);
  muaCluster.channelSD = sd;
  muaCluster.peakChannel = find(sd==max(sd),1);

  newClusters(end+1) = muaCluster;
  
  clusters = newClusters;
end
