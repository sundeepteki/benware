function [stim, stimInfo] = makeCalibTone(sweepNum, grid, expt)

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
cal = load('E:\Christian\Thesis\Chapter 2\Experiments\Anesthetized\Animals\R1711\Sets\Calibrated\DRCs_Anesthetized3_FRS8.mat');
compensationFilter = cal.stim_set.stimuli(1).FIRCoeff;
stim = conv(stim, compensationFilter);
stim = stim*10^((grid.stimLevelOffsetDB + level)/20);
