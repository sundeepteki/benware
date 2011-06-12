function altName = verifySaveDir(grid, expt)
% determine whether the data directory specified by grid.name already
% exists. If it does, allow user to decide whether to delete it or
% to use an alternative directory (named .2 etc).

dataDir = constructDataPath(grid.dataDir(1:end-1), grid, expt);

% use the default dir if it doesn't yet exist
if ~exist(dataDir, 'dir')
  altName = '';
  return
end

% find the first unused suffix
suffixNum = 2;
suffixStr = ['.' n2s(suffixNum)];
lastFoundStr = '';

while exist([dataDir suffixStr], 'dir')
  lastFoundStr = suffixStr;
  suffixNum = suffixNum + 1;
  suffixStr = ['.' n2s(suffixNum)];
end

% construct alternative directory name
if isunix | ismac
  directoryDelimiter = '/';
elseif ispc
  directoryDelimiter = '\';
end
f = find(dataDir == directoryDelimiter);
altDir = [dataDir(f(end)+1:end) suffixStr];

% prompt user
promptTitle = ['Data directory ' dataDir(f(end)+1:end) lastFoundStr  ...
		    ' already exists'];
promptStr = ['  - [o] overwrite\n' ...
	     '  - [a] use alternative dir: ' altDir '\n' ...
	     '  - [k] keyboard\n\n'];

% parse response
repeatLoop = true;
while repeatLoop

  fprintf_subtitle(promptTitle);
  fprintf(promptStr);
  r = demandinput({'o', 'a', 'k'});
  
  switch r
    % overwrite
    case 'o'
      deleteStr = sprintf('About to delete %s. Sure? [y/n]\n', ...
			  regexprep([dataDir lastFoundStr], '\', '\\\'));
      fprintf(deleteStr);
      r2 = demandinput({'y', 'n'});
      if r2=='y'
        rmdir([dataDir lastFoundStr], 's');
        altName = [grid.name lastFoundStr];
	repeatLoop = false;
      end
    
    % alternative dir
    case 'a'
      altName = [grid.name suffixStr];
      repeatLoop = false;
    
    % keyboard mode
    case 'k'
      keyboard;

  end

end 

