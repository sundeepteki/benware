function subdirName = chooseOntehflyDirectory(sourceRootDir)
% subdirName = chooseOntehflyDirectory(sourceRootDir)

% find subdirectories
subdirs = dir([fixpath(sourceRootDir) 'P*']);
nSubdirs = L(subdirs);
for ii=1:nSubdirs
  subdirs(ii).fullname = [fixpath(sourceRootDir) subdirs(ii).name '/'];
  subdirs(ii).isBenWare = L(dir([subdirs(ii).fullname 'gridInfo.mat'])) == 1;
  subdirs(ii).isNoise = L(strfind(subdirs(ii).name, 'bilateral.noise')) > 0;
end
subdirs = subdirs([subdirs.isBenWare]);
subdirs = subdirs(~[subdirs.isNoise]);
nSubdirs = L(subdirs);

% sort these by date
[junk sort_idx] = sort([subdirs.datenum]);
subdirs = subdirs(sort_idx);

% display
fprintf_subtitle('choose data to analyse:');
for ii=1:nSubdirs
  fprintf('  - [%d]: %s\n', ii, subdirs(ii).name);
end
fprintf('\n');

% ask the user
n = demandnumberinput('     >>> ', 1:nSubdirs, nSubdirs);
subdirName = subdirs(n).name;