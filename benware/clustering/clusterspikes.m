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
  [paramsFile, nSitesPerShank] = benware2spikedetekt(dirs{dirIdx});

  done_detekting = false;
  try
    spikedetektDirs = getdirsmatching([dir filesep 'spikedetekt_*/']);
    spikedetektDir = spikedetektDirs{end};
    if exist([spikedetektDir filesep 'done.txt'], 'file')
      done_detekting = true;
    end
  catch
    done_detekting = false;
  end

  if done_detekting
  fprintf('Found complete spikedetekt data in %s; skipping spike detection\n', spikedetektDir);
  else
    cmd = ['cd ' dir filesep 'spikedetekt' '; ' ...
           'LD_LIBRARY_PATH='''' DYLD_LIBRARY_PATH='''' DYLD_FRAMEWORK_PATH='''' python ' pwd '/klustakwik/detektspikes.py ' paramsFile ' | grep -v --line-buffered Unalignable'];
    fprintf('= Detecting spikes by running command:\n %s\n', cmd);
    system(cmd);
    spikedetektDirs = getdirsmatching([dir filesep 'spikedetekt_*/']);
    spikedetektDir = spikedetektDirs{end};
    cmd = ['echo done > ' spikedetektDir filesep 'done.txt'];
    system(cmd);
  end

  for shankIdx = 1:nShanks
    parameters = ['-UseDistributional 1 -MaxPossibleClusters ' num2str(nSpikesPerShank(shankIdx)) ' -MaskStarts ' num2str(ceil(nSpikesPerShank(shankIdx)/2)) ' -PenaltyK 1 -PenaltyKLogN 0 -DropLastNFeatures 1'];
    cmd = sprintf(['cd ' spikedetektDir '; ' ...
                   'LD_LIBRARY_PATH='''' DYLD_LIBRARY_PATH='''' DYLD_FRAMEWORK_PATH='''' ' pwd '/klustakwik/KlustaKwik.' computer ' ' paramsFile(1:end-7) ' %d ' parameters], shankIdx);
    fprintf('Clustering shank %d by running command:\n %s\n', shankIdx, cmd);
    system(cmd);
  end
end
