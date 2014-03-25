function clusterspikes(parentDir)

setpath;

try
  d0 = {};
  d0 = getfilesmatching([parentDir '/gridInfo.mat']);
catch
  %
end

try
  d1 = {};
  d1 = getfilesmatching([parentDir '/*/gridInfo.mat']);
catch
  %
end

try
  d2 = {};
  d2 = getfilesmatching([parentDir '/*/*/gridInfo.mat']);
catch
  %
end

dirs = cat(1, d0, d1, d2);
dirs = cellfun(@(x) x(1:end-length('/gridInfo.mat')), dirs, 'uni', false);

for dirIdx = 1:length(dirs)
  dir = dirs{dirIdx};
  [paramsFile, nShanks] = benware2spikedetekt(dirs{dirIdx});
  cmd = ['cd ' dir filesep 'spikedetekt' '; ' ...
         'DYLD_LIBRARY_PATH='''' DYLD_FRAMEWORK_PATH='''' python ' pwd '/klustakwik/detektspikes.py ' paramsFile];
  fprintf('= Detecting spikes by running command:\n %s', cmd);
  system(cmd);
  spikedetektDirs = getdirsmatching([dir filesep 'spikedetekt_*/']);
  spikedetektDir = spikedetektDirs{end};
  
  for shankIdx = 1:nShanks
    parameters = '-UseDistributional 1 -MaxPossibleClusters 500 -MaskStarts 300 -PenaltyK 1 -PenaltyKLogN 0 -DropLastNFeatures 1';
    cmd = sprintf(['cd ' spikedetektDir '; ' ...
                   'DYLD_LIBRARY_PATH='''' DYLD_FRAMEWORK_PATH='''' ' pwd '/klustakwik/KlustaKwik.' computer ' ' paramsFile(1:end-7) ' %d ' parameters], shankIdx);
    fprintf('Clustering shank %d by running command:\n %s', shankIdx, cmd);
    system(cmd);
  end
end
