function setPath
% setpath
%
% set path for benWare

if ispc
  if exist('..\NeilLib', 'dir')
    addpath(genpath('..\NeilLib'));
  elseif exist('.\NeilLib', 'dir')
    addpath(genpath('.\NeilLib'));
  end
  addpath(genpath(pwd));
else
  addpath([pwd '/../NeilLib/']);
  addpath(genpath(pwd));
end