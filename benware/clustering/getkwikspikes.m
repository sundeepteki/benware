function clusters = getkwikspikes(kwikfile)

re = regexp(kwikfile, '(.*)/.*/.*', 'tokens');
exptdir = re{1}{1};

% get info about sample rate
l = load([exptdir filesep 'gridInfo.mat']);
f_s = l.expt.dataDeviceSampleRate;

% get info about sweep lengths
l = load([exptdir filesep 'spikedetekt' filesep 'sweep_info.mat']);
sweepLens = l.sweepLens;

info = h5info(kwikfile);
shankid = info.Groups(2).Groups(1).Name;
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

waveform_data = h5read(kwikfile, [shankid '/waveforms']);

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

  cluster.waveforms = waveform_data.waveform_filtered(:,clusterID==cluster.clusterID);

  clusters{ii} = cluster;
  
end
clusters = [clusters{:}];
