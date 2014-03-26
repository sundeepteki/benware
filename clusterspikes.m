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
  nShanks = length(nSitesPerShank);

  done_detekting = false;
  try
    spikedetektDirs = getdirsmatching([dir filesep 'spikedetekt_*/']);

    % sort to get the last one
    res = cellfun(@(x) regexp(x, 'spikedetekt_([0-9]+)', 'tokens'), spikedetektDirs, 'uni', false);
    n = cellfun(@(x) eval(x{1}{1}), res)';
    [srt, idx] = sort(n);
    spikedetektDirs = spikedetektDirs(idx);
    spikedetektDir = spikedetektDirs{end};

    if exist([spikedetektDir filesep 'detektion_done.txt'], 'file')
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
    res = system(cmd);
    if res>0
      error('Command failed');
    end
    spikedetektDirs = getdirsmatching([dir filesep 'spikedetekt_*/']);
    spikedetektDir = spikedetektDirs{end};
    cmd = ['echo done > ' spikedetektDir filesep 'detektion_done.txt'];
    system(cmd);
  end

  for shankIdx = 1:nShanks
    if exist(sprintf([spikedetektDir filesep 'klustering_done.%d.txt'], shankIdx), 'file')
      fprintf('= Shank %d already clustered, skipping\n', shankIdx);
    else
      parameters = ['-UseDistributional 1 -MaxPossibleClusters ' num2str(nSitesPerShank(shankIdx)) ' -MaskStarts ' num2str(ceil(nSitesPerShank(shankIdx)/2)) ' -PenaltyK 1 -PenaltyKLogN 0 -DropLastNFeatures 1'];
      cmd = sprintf(['cd ' spikedetektDir '; ' ...
                   'LD_LIBRARY_PATH='''' DYLD_LIBRARY_PATH='''' DYLD_FRAMEWORK_PATH='''' ' pwd '/klustakwik/KlustaKwik.' computer ' ' paramsFile(1:end-7) ' %d ' parameters], shankIdx);
      fprintf('= Clustering shank %d by running command:\n %s\n', shankIdx, cmd);
      res = system(cmd);
      if res>0
        error('Command failed');
      end
      cmd = sprintf(['echo done > ' spikedetektDir filesep 'klustering_done.%d.txt'], shankIdx);
      system(cmd);
    end
  end
end
