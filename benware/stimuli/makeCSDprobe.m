function stim = makeCSDprobe(sampleRate, nChannels, duration, delay, len, level)

% convert to samples
duration = ceil(duration/1000*sampleRate);
delay = round(delay/1000*sampleRate);
len = round(len/1000*sampleRate);

stimLen_samples = duration;

uncalib = zeros(1, stimLen_samples);
uncalib(1, delay:delay+len-1) = randn(1, len); 

% provide 2 (dichotic) channels if nChannels = 2
stim = repmat(uncalib, nChannels, 1);

% apply level
level_offset = level-80;
stim = stim*10^(level_offset)/20;
