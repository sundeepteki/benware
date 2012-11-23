function [stim, stimInfo] = makeCalibTone2(sweepNum, grid, expt)
% never used

stimInfo.stimGridTitles = grid.stimGridTitles;
stimInfo.stimParameters = grid.randomisedGrid(sweepNum, :);

parameters = grid.randomisedGrid(sweepNum,1:end);

freq = parameters(1);
duration = parameters(2);
level = parameters(3);

% time
t = 0:1/grid.sampleRate:duration/1000;

% sinusoid (not bothering with ramp)
stim = sin(2*pi*freq*t);

% convolve with compensation filter
stim = conv(stim, grid.compensationFilter);
stim = stim*10^((grid.stimLevelOffsetDB + level)/20);
