function stim = makeCalibToneWithLight(expt, grid, sampleRate, nChannels, compensationFilters, ...
								duration, freq, delay, len, lightvoltage, lightdelay, lightduration, level)


if nChannels~=2
	errorBeep('CalibToneWithLight requires expt.nStimChannels=2');
end                            

stimLen_samples = ceil(duration/1000*grid.sampleRate);
% time
t = 0:1/grid.sampleRate:len/1000;

% sinusoid
tone = sin(2*pi*freq*t);
delay = zeros(1, ceil(delay/1000*grid.sampleRate));
remainder = zeros(1, (stimLen_samples-length(tone)-length(delay)));

% ramp up and down
ramplen_samples = round(5/1000*grid.sampleRate);
ramp = (1-cos(pi*(1:ramplen_samples)/ramplen_samples))/2;
env = [ramp ones(1,length(tone)-2*length(ramp)) fliplr(ramp)];
tone = tone.*env;

uncalib = [delay tone remainder];

% convolve with compensation filter
% now just multiplying by appropriate value instead
for chan = 1:length(grid.compensationFilters)
    cf = grid.compensationFilters{chan};
 
    ft = abs(fft(cf));
    ft = ft(1:length(ft)/2);
    f = linspace(0, grid.sampleRate/2, length(ft));

    amp = interp1(f, ft, freq);
    stimulus(chan, :) = uncalib * amp;
end

for chan = length(compensationFilters)+1:nChannels
  stim(chan, :) = 0;
end

stim = nan(2, length(uncalib));
%stim in channel 1
stim(1, :) = stimulus;

lightdelay = ceil(lightdelay/1000*grid.sampleRate);
lightduration = ceil(lightduration/1000*grid.sampleRate);
% light in channel 2
lightstim = zeros(1, stimLen_samples);
lightstim(1, lightdelay:min(stimLen_samples, lightdelay+lightduration-1)) = lightvoltage;

stim(2, :) = lightstim;

% set level correctly
uncalib = uncalib*sqrt(2);
uncalib = uncalib * 10^((level-94) / 20);

stim(1,:) = repmat(uncalib, 1, 1);

