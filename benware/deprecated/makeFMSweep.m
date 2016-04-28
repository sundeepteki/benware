function stim = makeFMSweep(expt, grid, sampleRate, nChannels, compensationFilters, duration, F0, F1, level)

% time
t = 0:1/grid.sampleRate:duration/1000;
f = logspace(log10(F0), log10(F1), length(t));

% sinusoid
uncalib = sin(2*pi*f);

% ramp up and down
ramplen_samples = round(5/1000*grid.sampleRate);
ramp = (1-cos(pi*(1:ramplen_samples)/ramplen_samples))/2;
env = [ramp ones(1,length(uncalib)-2*length(ramp)) fliplr(ramp)];
uncalib = uncalib.*env;

% convolve with compensation filter
% % now just multiplying by appropriate value instead
% for chan = 1:length(grid.compensationFilters)
%     cf = grid.compensationFilters{chan};
%  
%     ft = abs(fft(cf));
%     ft = ft(1:length(ft)/2);
%     f = linspace(0, grid.sampleRate/2, length(ft));
% 
%     amp = interp1(f, ft, freq);
%     stim(chan, :) = uncalib * amp;
% end
% 
% for chan = length(compensationFilters)+1:nChannels
%   stim(chan, :) = 0;
% end

stim = [uncalib; uncalib];

% apply level offset
level_offset = level-80;
stim = stim * (10^(level_offset) / 20);
