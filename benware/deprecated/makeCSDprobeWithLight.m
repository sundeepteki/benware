function stim = makeCSDprobeWithLight(expt, grid, sampleRate, nChannels, compensationFilters, ...
									duration, delay, len, lightvoltage, lightdelay, lightduration, level)

if nChannels~=2
	errorBeep('CSDprobeWithLight requires expt.nStimChannels=2');
end

% convert times to samples
duration = ceil(duration/1000*grid.sampleRate);
delay = round(delay/1000*grid.sampleRate);
len = round(len/1000*grid.sampleRate);
lightdelay = ceil(lightdelay/1000*grid.sampleRate);
lightduration = ceil(lightduration/1000*grid.sampleRate);

stimLen_samples = duration;

% sound in channel 1
uncalib = zeros(1, stimLen_samples);
uncalib(1, delay:delay+len-1) = randn(1, len); 

stim = nan(2, length(uncalib));
stim(1,:) = uncalib;

% light in channel 2
lightstim = zeros(1, stimLen_samples);
lightstim(1, lightdelay:min(stimLen_samples, lightdelay+lightduration-1)) = lightvoltage;

stim(2,:) = lightstim;

% apply level to sound channel only
level_offset = level-94;
stim(1,:) = stim(1,:)*10^(level_offset/20);
