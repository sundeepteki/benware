%% initial setup
% =================

% path
if ispc
  addpath(genpath('D:\auditory-objects\NeilLib'));
  addpath(genpath(pwd));
else
  addpath([pwd '/../NeilLib/']);
  addpath(genpath(pwd));
end

% welcome
printGreetings()

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
if checkdata
  fprintf('Downloading all data twice! this is for testing only!\n');
  needWarning = true;
end

if needWarning
  fprintf('Press a key to continue.\n');
  pause;
end


%% stim/data setup: USER
% =======================

% experiment details
clear expt grid;

expt.exptNum = 31;

expt.stimDeviceName = 'RX6';

expt.dataDeviceName = 'RZ5';
expt.dataDeviceSampleRate = 24414.0625;

expt.penetrationNum = 14;
expt.probe.lhs = '284B';
expt.probe.rhs = '2840';
expt.headstage.lhs = 3078;
expt.headstage.rhs = 3455;
channelMapping = [9 8 10 7 13 4 12 5 15 2 16 1 14 3 11 6];
expt.channelMapping = [channelMapping channelMapping+16];

if ispc
  expt.dataDir = 'F:\auditory-objects.data\expt%E\%P-%N\';
  expt.dataFilename = 'raw.f32\%P.%N.sweep.%S.channel.%C.f32';
  expt.sweepFilename = 'sweep.mat\%P.%N.sweep.%S.mat';
else
  expt.dataDir = './expt-%E/%P-%N/';
  expt.dataFilename = 'raw.f32/%P.%N.sweep.%S.channel.%C.f32';
  expt.sweepFilename = 'sweep.mat/%P.%N.sweep.%S.mat';
end

expt.logFilename = 'benWare.log';
expt.plotFunctions.init = 'scopeTraceFastInit';
expt.plotFunctions.reset = 'scopeTraceFastReset';
expt.plotFunctions.plot = 'scopeTraceFastPlot';
%expt.dataGain = 100;
expt.detectSpikes = true;
expt.spikeThreshold = -2.8;
%expt.plotFunctions.preGrid = 'rasterPreGrid';
%expt.plotFunctions.preSweep = 'rasterPreSweep';
%expt.plotFunctions.plot = 'rasterPlot';

% load grid from grids/ directory
grid = chooseGrid();

% run grid
if ~exist('tdt','var')
  tdt = [];
end

tdt = runGrid(tdt, expt, grid);
