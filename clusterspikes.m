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
           'LD_LIBRARY_PATH='''' DYLD_LIBRARY_PATH='''' DYLD_FRAMEWORK_PATH='''' python ' pwd '/klustakwik/detektspikes.py ' paramsFile];
    fprintf('= Detecting spikes by running command:\n %s\n', cmd);
    res = system(cmd);
    if res>0
      error('Command failed');
    end
    spikedetektDirs = getdirsmatching([dir filesep 'spikedetekt_*/']);
    % sort to get the last one
    res = cellfun(@(x) regexp(x, 'spikedetekt_([0-9]+)', 'tokens'), spikedetektDirs, 'uni', false);
    n = cellfun(@(x) eval(x{1}{1}), res)';
    [srt, idx] = sort(n);
    spikedetektDirs = spikedetektDirs(idx);
    spikedetektDir = spikedetektDirs{end};
    cmd = ['echo done > ' spikedetektDir filesep 'detektion_done.txt'];
    system(cmd);
  end

  for shankIdx = 1:nShanks
    if exist(sprintf([spikedetektDir filesep 'klustering_done.%d.txt'], shankIdx), 'file')
      fprintf('= Shank %d already clustered, skipping\n', shankIdx);
    else
      f = getfilesmatching(sprintf([spikedetektDir filesep '*.clu.%d'], shankIdx));
      tmp = cluread(f{1});
      if isempty(tmp)
        fprintf('= No clusters for shank %d, skipping\n', shankIdx);
        continue;
      end
      if nSitesPerShank(shankIdx)==1
        parameters = ['-MinClusters 5 -MaxClusters 10 -MaxPossibleClusters 20 -PenaltyK 1 -PenaltyKLogN 0 -DropLastNFeatures 1'];
      else
        parameters = ['-UseDistributional 1 -MaxPossibleClusters ' num2str(nSitesPerShank(shankIdx)) ' -MaskStarts ' num2str(ceil(nSitesPerShank(shankIdx)/2)) ' -PenaltyK 1 -PenaltyKLogN 0 -DropLastNFeatures 1'];
      end
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
  
  % move to shank-specific directories
  for shankIdx = 1:nShanks
    shankDir = sprintf([parentDir filesep 'shank.%d'], shankIdx);
    if ~exist(shankDir, 'dir')
      mkdir(shankDir);
    end
    copyfile(sprintf([spikedetektDir filesep '*.%d'], shankIdx), shankDir); 
    copyfile([parentDir filesep 'spikedetekt' filesep '*.probe'], shankDir); 
    copyfile([spikedetektDir filesep '*.xml'], shankDir); 
  end
end
