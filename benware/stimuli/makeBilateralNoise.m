function stim = makeBilateralNoise(expt, grid, sampleRate, nChannels, compensationFilters, ...
									duration, leftDelay, rightDelay, bothDelay, level)
% function stim = makeBilateralNoise(sampleRate, nChannels, duration, leftDelay, rightDelay, bothDelay, level)
% generate L-R-both bilateral noise stimulus
% used as a search stimulus by Ben

if nChannels~=2
	errorBeep('Bilateral noise requires expt.nStimChannels=2');
end

% convert lengths from ms to samples
duration = ceil(duration/1000*sampleRate);
leftDelay = ceil(leftDelay/1000*sampleRate);
rightDelay = ceil(rightDelay/1000*sampleRate);
bothDelay = ceil(bothDelay/1000*sampleRate);
stimLen = bothDelay + duration;

% 2.5 ms for the ramp is 10 ms for the whole cycle
rampT = round(10/1000*sampleRate);

% 2*pi*f*t
ramp = sin(2*pi*(1/rampT)*(1:rampT/4));

stim = rand(2,stimLen)*2-1;

envL = [zeros(1,leftDelay),ramp,ones(1,duration-2*length(ramp)),fliplr(ramp)];
envL = [envL zeros(1,bothDelay-length(envL))];

envR = [zeros(1,rightDelay),ramp,ones(1,duration-2*length(ramp)),fliplr(ramp)];
envR = [envR zeros(1,bothDelay-length(envR))];

envBoth = [ramp,ones(1,duration-2*length(ramp)),fliplr(ramp)];
envBoth = [envBoth zeros(1,stimLen-length(envBoth)-length(envL))];

envL = [envL envBoth];
envR = [envR envBoth];

stim = stim.*[envL; envR];

% apply level offset
level_offset = level-80;
stim = stim * 10^(level_offset(1) / 20);
