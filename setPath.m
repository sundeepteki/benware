function setPath
% setpath
%
% set path for benWare

if ispc
  addpath(genpath('E:\auditory-objects\NeilLib'));
  addpath(genpath(pwd));
else
  addpath([pwd '/../NeilLib/']);
  addpath(genpath(pwd));
end