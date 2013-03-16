function setPath
% setpath
%
% set path for benWare

addpath(genpath(fix_slashes('./benware/')));

load user.mat;
addpath(fix_slashes(['./grids/grids.' user.name]));
