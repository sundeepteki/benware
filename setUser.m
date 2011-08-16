function setUser(name)

name = lower(name);

exptFilename = [fixpath('./') 'expt.mat'];
newPath = fixpath(['./userinfo/' name '/']);
if ~exist(newPath, 'dir')
  error(['No user info found in ' newPath]);
end

if exist(exptFilename, 'file')
  % then move existing stash to backup and move existing expt/grids to stash
  
  l = load(exptFilename);
  oldName = l.expt.userName;
  
  if strcmp(oldName, name)
    error(['expt.userName is already ' name]);
  end
  
  stashPath = fixpath(['./userinfo/' oldName '/']);
  backupPath = fixpath(['./userinfo/' oldName '.old/']);

  if exist([stashPath 'expt.mat'], 'file') | exist([stashPath 'grids'], 'dir')
    if exist(backupPath, 'dir')
      delete(backupPath);
    end
    fprintf(['Moving ' stashPath ' to ' backupPath '\n']);
    movefile(stashPath, backupPath);
  end
  
  fprintf(['Moving expt.mat and grids to ' stashPath '\n']);
  mkdir_nowarning(stashPath);
  movefile(exptFilename, stashPath);
  gridsPath = [fixpath('./') 'grids'];
  if exist(gridsPath, 'dir')
    movefile(gridsPath, stashPath);
  end

end

fprintf(['Fetching expt.mat and grids from ' newPath '\n']);
movefile([newPath 'expt.mat'], '.');
movefile([newPath 'grids'], '.');
