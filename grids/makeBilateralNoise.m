function [stim, stimInfo] = makeBilateralNoise(sweepNum, grid, expt)

stimInfo.stimGridTitles = grid.stimGridTitles;
stimInfo.stimParameters = grid.randomisedGrid(sweepNum, :);

parameters = ceil(grid.randomisedGrid(sweepNum,1:end-1)/1000*grid.sampleRate);
duration = parameters(1);
leftDelay = parameters(2);
rightDelay = parameters(3);
bothDelay = parameters(4);

stimLen_samples = bothDelay + duration;


% 2.5 ms for the ramp is 10 ms for the whole cycle
rampT = round(10/1000*grid.sampleRate);

% 2*pi*f*t
ramp = sin(2*pi*(1/rampT)*(1:rampT/4));

stim = rand(2,stimLen_samples)*2-1;

envL = [zeros(1,leftDelay),ramp,ones(1,duration-2*length(ramp)),fliplr(ramp)];
envL = [envL zeros(1,bothDelay-length(envL))];

envR = [zeros(1,rightDelay),ramp,ones(1,duration-2*length(ramp)),fliplr(ramp)];
envR = [envR zeros(1,bothDelay-length(envR))];

envBoth = [ramp,ones(1,duration-2*length(ramp)),fliplr(ramp)];
envBoth = [envBoth zeros(1,stimLen_samples-length(envBoth)-length(envL))];

envL = [envL envBoth];
envR = [envR envBoth];

stim = stim.*[envL; envR];
stim = stim*10^((grid.stimLevelOffsetDB + stimInfo.stimParameters(end))/20);
