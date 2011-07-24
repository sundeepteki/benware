%% initial setup
% =================

% set path
setPath;

% welcome
printGreetings;

% variables intended for manipulation by future UI
global state %#ok<NUSED>

global truncate checkdata;
truncate = 0; % for testing only. should normally be 0
checkdata = false; % for testing only. should normally be FALSE

% testing notices
needWarning = false;

if truncate~=1
  fprintf('Truncating stimuli! This is for testing only!\n');
  needWarning = true;
end

if checkdata~=0
  fprintf('Reloading data for checking. For testing only!\n');
  needWarning = true;
end

if needWarning
  fprintf('Press a key to continue.\n');
  pause;
end

%% initialise global variables (state)
initGlobalVariables;

%% load and set defaults for expt structure
%% which contains persistent information about the experiment

% experiment details
clear expt grid;

% load the structure
load expt.mat;

% set defaults
if ispc
  expt.exptDir = [expt.dataRoot 'expt%E\'];
  expt.dataDir = [expt.exptDir '%P-%N\'];
  expt.dataFilename = 'raw.f32\%P.%N.sweep.%S.channel.%C.f32';
  expt.sweepFilename = 'sweep.mat\%P.%N.sweep.%S.mat';
else
  expt.exptDir = './expt%E/';
  expt.dataDir = [expt.exptDir '%P-%N/'];
  expt.dataFilename = 'raw.f32/%P.%N.sweep.%S.channel.%C.f32';
  expt.sweepFilename = 'sweep.mat/%P.%N.sweep.%S.mat';
  global fakeHardware %#ok<TLEV>
  fakeHardware = true;
end

expt.logFilename = 'benWare.log';
expt.spikeThreshold = -3.2; % -2.8
expt.nChannels = length(expt.channelMapping);

%% load and set defaults for grid structure
%% which contains specifications for the current grid

% check whether the most recent grid was interrupted. if so, offer to load
% it and continue with it.
gotGrid = false;
[gridFile, lastSweep] = checkForInterruptedGrid(constructDataPath(expt.exptDir, [], expt), expt);
if ~isempty(gridFile)
  l = load(gridFile);
  fprintf_title('Interrupted grid found!');
  if isempty(l.grid.saveName)
    name = l.grid.name;
  else
    name = l.grid.saveName;
  end
  i = demandinput(sprintf('Do you want to resume %s? [y/N] ', name), 'yn', 'n', true);
  
  if lower(i)=='y'
    fprintf('The last recorded sweep was %d.\n', lastSweep);
    firstSweep = demandnumberinput(sprintf('Which sweep do you want to resume from? [%d] ', lastSweep+1), 1:lastSweep+1, lastSweep+1);
    gotGrid = true;
    grid = l.grid;    
  end
  
end

if ~gotGrid
  % load grid from grids/ directory
  grid = chooseGrid();
  
  % verify grid, randomise it, save grid metadata to disk
  grid = prepareGrid(grid, expt);
  
  firstSweep = 1;
end


%% prepare TDT
if ~exist('tdt','var')
  tdt = [];
end
tdt = prepareTDT(tdt, expt, grid);

%% run the grid
runGrid(tdt, expt, grid, firstSweep);


