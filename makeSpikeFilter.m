function spikeFilter = makeSpikeFilter(fs)

Wp = [300 3000];
n = 2;
[spikeFilter.B,spikeFilter.A] = ellip(n, 0.01, 40, Wp/(fs/2));

% arbitrary
spikeFilter.deadTime = 50;
