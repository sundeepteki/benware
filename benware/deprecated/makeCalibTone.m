function stim = makeCalibTone(expt, grid, sampleRate, nChannels, compensationFilters, ...
								freq, duration, level)
% deprecated: used stimgen_makeTone instead

% time
t = 0:1/grid.sampleRate:duration/1000;

% sinusoid
uncalib = sin(2*pi*freq*t);

% ramp up and down
ramplen_samples = round(5/1000*grid.sampleRate);
ramp = (1-cos(pi*(1:ramplen_samples)/ramplen_samples))/2;
env = [ramp ones(1,length(uncalib)-2*length(ramp)) fliplr(ramp)];
uncalib = uncalib.*env;

% set level correctly
uncalib = uncalib*sqrt(2);
uncalib = uncalib * 10^((level-94) / 20);

stim = repmat(uncalib, nChannels, 1);
