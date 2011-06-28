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
global dataGain

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

expt.exptNum = 98;

expt.stimDeviceName = 'RX6';

expt.dataDeviceName = 'RZ5';
expt.dataDeviceSampleRate = 24414.0625;

expt.penetrationNum = 99;
expt.probe.lhs = 2920;
expt.probe.rhs = 2940;
expt.headstage.lhs = 3455;
expt.headstage.rhs = 3078;
channelMapping = [9 8 10 7 13 4 12 5 15 2 16 1 14 3 11 6];
expt.channelMapping = [channelMapping channelMapping+16];

if ispc
  expt.dataDir = 'F:\auditory-objects.data\expt%E\%P-%N\';
  expt.dataFilename = 'raw.f32\%P.%N.sweep.%S.channel.%C.f32';
  expt.spikeFilename = 'spike.mat\%P.%N.sweep.%S.mat';
else
  expt.dataDir = './expt-%E/%P-%N/';
  expt.dataFilename = 'raw.f32/%P.%N.sweep.%S.channel.%C.f32';
  expt.spikeFilename = 'spike.mat/%P.%N.sweep.%S.mat';
end

expt.logFilename = 'benWare.log';
expt.plotFunctions.init = 'scopeTraceFastInit';
expt.plotFunctions.plot = 'noPlot';
expt.dataGain = 1000;
expt.detectSpikes = true;
expt.spikeThreshold = -2.8;
%expt.plotFunctions.preGrid = 'rasterPreGrid';
%expt.plotFunctions.preSweep = 'rasterPreSweep';
%expt.plotFunctions.plot = 'rasterPlot';

% load grid from grids/ directory
grid = chooseGrid();

% prepare TDT
figure(99);
set_fig_size(100, 100, 99);
put_fig_in_bottom_right;

if ~exist('tdt','var')
  tdt = struct();
end

if ~isfield(tdt,'zBus')
  tdt.zBus = [];
end
tdt.zBus = zBusInit(tdt.zBus);

if ~isfield(tdt,'stimDevice')
  tdt.stimDevice = [];
end
[tdt.stimDevice, tdt.stimSampleRate] = stimDeviceInit(tdt.stimDevice, expt.stimDeviceName, grid.sampleRate);

if ~isfield(tdt,'dataDevice')
  tdt.dataDevice = [];
end
[tdt.dataDevice, tdt.dataSampleRate] = dataDeviceInit(tdt.dataDevice, expt.dataDeviceName, expt.dataDeviceSampleRate, expt.channelMapping);

fprintf('  * Post-initialisation pause...');
pause(2);
fprintf('done.\n');

% check sample rates are identical to those requested
if tdt.stimSampleRate ~= grid.sampleRate
  error('stimDevice sample rate is wrong');
end

if tdt.dataSampleRate ~= expt.dataDeviceSampleRate
  error('dataDevice sample rate is wrong');
end

% run grid
runGrid(expt, grid, tdt);
