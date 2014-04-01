function clusterspikes(parentDir)
if ispc
  filesep = '\\'; % yet another Matlab WTF... :/ - needed avoid invalid escape sequences in sprintf
else
  filesep = '/';
end

setpath;

if ~exist(parentDir, 'dir')
  error(sprintf('%s not found'), parentDir);
end

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

singleFile = true;

for dirIdx = 1:length(dirs)
  dir = dirs{dirIdx};
  fprintf('== Processing %s\n', dir);

  % check if data has been converted; if not, convert it
  sweepInfoFile = [dir filesep 'spikedetekt/sweep_info.mat'];
  if exist(sweepInfoFile, 'file')
    fprintf('Found %s; skipping conversion\n', sweepInfoFile);
    l = load(sweepInfoFile);
    paramsFile = l.paramsFile;
    nSitesPerShank = l.nSitesPerShank;
    
  else
    if singleFile
      [paramsFile, nSitesPerShank] = benware2spikedetekt_singlefile(dirs{dirIdx});
    else
      [paramsFile, nSitesPerShank] = benware2spikedetekt(dirs{dirIdx});
    end
  end
  nShanks = length(nSitesPerShank);

  % check if spikes have been detected; if not, detect them
  spikedetektDir = getLastSpikedetektDir(dir);
  if ~isempty(spikedetektDir) && exist([spikedetektDir filesep 'detektion_done.txt'], 'file')
    fprintf('Found complete spikedetekt data in %s; skipping spike detection\n', spikedetektDir);

  else
    if ispc
      [status,windows_path] = system('PATH'); % we need to get rid of Matlab in our PATH as otherwise scipy will load wrong DLLs from Matlab installation
      pos = strfind(windows_path,';');
      cmd = [tempdir 'benware.bat'];
      fid = fopen(cmd,'w');
      fprintf(fid,'cd %s/spikedetekt\n',dir);
      fprintf(fid,'set PATH=%s\n',windows_path(pos(1)+1:end));
      fprintf(fid,'python %s/klustakwik/detektspikes.py %s\n',pwd,paramsFile);
      fclose(fid);
    else
      cmd = ['cd ' escapespaces([dir filesep 'spikedetekt']) '; ' ...
           'LD_LIBRARY_PATH='''' DYLD_LIBRARY_PATH='''' DYLD_FRAMEWORK_PATH='''' ' ...
           'PATH=~/Library/Enthought/Canopy_64bit/User/bin/:Library/Enthought/Canopy_32bit/User/bin/:$PATH ' ...
           'python ' pwd '/klustakwik/detektspikes.py ' paramsFile];
    end
    
    fprintf('= Detecting spikes by running command:\n %s\n', cmd);
    res = 0; % system(cmd); % TODO: python / spikedetekt will crash if there is not enough diskspace - handle this
    
    if res>0
      error('Command failed');
    end

    spikedetektDir = getLastSpikedetektDir(dir);
    
    if ispc
      fid = fopen(sprintf('%s/detektion_done.txt',spikedetektDir),'w');
      fprintf(fid,'done\n');
      fclose(fid);
    else
      cmd = ['echo done > ' spikedetektDir filesep 'detektion_done.txt'];
      system(cmd);
    end
    
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
      if ispc
        [status,windows_path] = system('PATH'); % we need to get rid of Matlab in our PATH as otherwise scipy will load wrong DLLs from Matlab installation
        pos = strfind(windows_path,';');
        cmd = [tempdir 'benware.bat'];
        fid = fopen(cmd,'w');
        fprintf(fid,'cd %s\n',spikedetektDir);
        fprintf(fid,'set PATH=%s\n',windows_path(pos(1)+1:end));
        fprintf(fid,'%s\\klustakwik\\klustakwik.PCWIN.exe %s %d %s\n',pwd,paramsFile(1:end-7),shankIdx,parameters); % use 64 Bit version from https://github.com/klusta-team/klustakwik
        fclose(fid);
      else
        cmd = sprintf(['cd ' escapespaces(spikedetektDir) '; ' ...
                     'LD_LIBRARY_PATH='''' DYLD_LIBRARY_PATH='''' DYLD_FRAMEWORK_PATH='''' ' pwd '/klustakwik/KlustaKwik.' computer ' ' paramsFile(1:end-7) ' %d ' parameters], shankIdx);
      end
      fprintf('= Clustering shank %d by running command:\n %s\n', shankIdx, cmd);
      res = system(cmd);
      if res>0
        error('Command failed');
      end
      if ispc
        fid = fopen(sprintf('%s/klustering_done.%d.txt',spikedetektDir,shankIdx),'w');
        fprintf(fid,'done\n');
        fclose(fid);
      else
        cmd = sprintf(['echo done > ' spikedetektDir filesep 'klustering_done.%d.txt'], shankIdx);
        system(cmd);
      end
    end
  end
  
  % move to shank-specific directories
  for shankIdx = 1:nShanks
    shankDir = sprintf([dir filesep 'shank.%d'], shankIdx);
    if ~exist(shankDir, 'dir')
      mkdir(shankDir);
    end
    copyfile(sprintf([spikedetektDir filesep '*.%d'], shankIdx), shankDir); 
    copyfile([dir filesep 'spikedetekt' filesep '*.probe'], shankDir);
    copyfile([spikedetektDir filesep '*.xml'], shankDir); 
  end
end
