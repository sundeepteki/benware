function setPath
% setpath
%
% set path for benWare

addpath(genpath('./benware/'));

load user.mat;
addpath(['./grids/grids.' user.name]);
