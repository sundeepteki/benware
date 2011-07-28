function [stim, stimInfo] = makeNoiseBurst(sweepNum, grid, expt)

stimInfo.stimGridTitles = grid.stimGridTitles;
stimInfo.stimParameters = grid.randomisedGrid(sweepNum, :);

parameters = grid.randomisedGrid(sweepNum,1:end);

duration = ceil(parameters(1)/1000*grid.sampleRate);
level = parameters(2);

stimLen_samples = duration;

% 2.5 ms for the ramp is 10 ms for the whole cycle
rampT = round(10/1000*grid.sampleRate);

% 2*pi*f*t
ramp = sin(2*pi*(1/rampT)*(1:rampT/4));

stim = rand(2,stimLen_samples)*2-1;

env = [ramp,ones(1,duration-2*length(ramp)),fliplr(ramp)];

stim = stim.*[env; env];
stim = stim*10^((grid.stimLevelOffsetDB + level)/20);
