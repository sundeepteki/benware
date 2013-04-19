function setuser(name)

setpath;

% remove old user's grids from path
load user;
rmpath(fix_slashes(['./grids/grids.' user.name]));

% save new users's name in user.mat
name = lower(name);

user.name = name;

gridDir = fix_slashes(['grids/grids.' user.name]);
if ~exist(gridDir, 'dir')
  mkdir(gridDir);
end

exptFile = fix_slashes(['users/expt.' user.name '.mat']);
if ~exist(exptFile, 'file')
  copyfile(fix_slashes('users/expt.ben.mat'), exptFile);
end

save user user;

% add new user's grids to path
addpath(fix_slashes(['./grids/grids.' user.name]));
