function shankData = getClusteredSpikes(dir)

% spikedetektDirs = getdirsmatching([dir filesep 'spikedetekt_*']);
% 
% % sort to get the last one
% res = cellfun(@(x) regexp(x, 'spikedetekt_([0-9]+)', 'tokens'), spikedetektDirs, 'uni', false);
% n = cellfun(@(x) eval(x{1}{1}), res)';
% [srt, idx] = sort(n);
% spikedetektDirs = spikedetektDirs(idx);
% spikedetektDir = spikedetektDirs{end};

try
  %files = getfilesmatching([spikedetektDir filesep '*.fet.*']);
  files = getfilesmatching([dir filesep 'shank*' filesep '*.fet.*']);
catch
  error('No FET files found');
end

res = cellfun(@(x) regexp(x, 'fet.([0-9]+)', 'tokens'), files, 'uni', false);
n = cellfun(@(x) eval(x{1}{1}), res)';
[srt, idx] = sort(n);
files = files(idx);

shankData = {};
for shank = 1:length(files)
  shankData{shank} = struct;
  shankData{shank}.shanknum = shank;
  
  % fet file contains features and spike times
  fetfile = files{shank};
  shankData{shank}.fetfile = fetfile;
  % clu file contains cluster IDs
  clufile = regexprep(fetfile, '.fet.', '.clu.');
  shankData{shank}.clufile = clufile;

  fprintf('Loading data from fet file %s\n', fetfile);
  fet = fetload(fetfile);
  if isempty(fet)
    shankData{shank}.clusters = {};
    continue;
  end
  spikeTimes = fet(:,end); % in samples

  % load clu file
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
      f = find(sweepTimes(:,1)==ss & clusterID==cc);
      times{ss} = spikeTimes(f);
    end
    data.spikeTimes = times;
    clusterData{end+1} = data;
  end

  shankData{shank}.clusters = [clusterData{:}];
end
shankData = [shankData{:}];