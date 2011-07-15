%% initial setup
% =================

% set path
setPath;

% welcome
printGreetings;

% variables intended for manipulation by future UI
global state

global truncate fakedata checkdata;
truncate = 0; % for testing only. should normally be 0
fakedata = []; %load('fakedata.mat'); % for testing only. should normally be []
checkdata = false; % for testing only. should normally be FALSE

% testing notices
needWarning = false;

if truncate~=0
  fprintf('Truncating stimuli! This is for testing only!\n');
  needWarning = true;
end
if ~isempty(fakedata)
  fprintf('RECORDING FAKE DATA! this is for testing only!\n');
  needWarning = true;
end

if needWarning
  fprintf('Press a key to continue.\n');
  pause;
end


%% load and set defaults for expt structure
%% which contains persistent information about the experiment

% experiment details
clear expt grid;

% load the structure
load expt.mat;

% set defaults
if ispc
  expt.dataDir = [expt.dataRoot 'expt%E\%P-%N\'];
  expt.dataFilename = 'raw.f32\%P.%N.sweep.%S.channel.%C.f32';
  expt.sweepFilename = 'sweep.mat\%P.%N.sweep.%S.mat';
else
  expt.dataDir = './expt-%E/%P-%N/';
  expt.dataFilename = 'raw.f32/%P.%N.sweep.%S.channel.%C.f32';
  expt.sweepFilename = 'sweep.mat/%P.%N.sweep.%S.mat';
end

expt.logFilename = 'benWare.log';
expt.spikeThreshold = -3.2; % -2.8

%% load and set defaults for grid structure
%% which contains specifications for the current grid

%load grid from grids/ directory
grid = chooseGrid();

% run grid
if ~exist('tdt','var')
  tdt = [];
end

tdt = runGrid(tdt, expt, grid);
