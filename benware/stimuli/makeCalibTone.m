function [stim, stimInfo] = makeCalibTone(sweepNum, grid, expt)

stimInfo.stimGridTitles = grid.stimGridTitles;
stimInfo.stimParameters = grid.randomisedGrid(sweepNum, :);

parameters = grid.randomisedGrid(sweepNum,1:end);

freq = parameters(1);
duration = parameters(2);
level = parameters(3);

% time
t = 0:1/grid.sampleRate:duration/1000;

% sinusoid
uncalib = sin(2*pi*freq*t);

% ramp up and down
ramplen_samples = round(5/1000*grid.sampleRate);
ramp = (1-cos(pi*(1:ramplen_samples)/ramplen_samples))/2;
env = [ramp ones(1,length(uncalib)-2*length(ramp)) fliplr(ramp)];
uncalib = uncalib.*env;

% convolve with compensation filter
% now just multiplying by appropriate value instead
for chan = 1:length(grid.compensationFilters)
    cf = grid.compensationFilters{chan};
 
    ft = abs(fft(cf));
    ft = ft(1:length(ft)/2);
    f = linspace(0, grid.sampleRate/2, length(ft));

    amp = interp1(f, ft, freq);
    stim(chan, :) = uncalib * amp;
end

% apply level offset
for chan = 1:length(grid.compensationFilters)
	stim(chan, :) = stim(chan, :) * 10^((level+grid.stimLevelOffsetDB(chan)) / 20);
end
