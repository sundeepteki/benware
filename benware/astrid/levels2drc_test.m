f_s     = 48000;
complex = 200:200:4000;
n_chord = 100;
freqmat = repmat(complex',1,n_chord);
randmat = ones(size(freqmat)) + (2*rand(size(freqmat))-1)*0.1;
freqs   = freqmat.*randmat;
levels  = rand(length(complex),n_chord)*50+30;
chord_duration = 0.025;
ramp_duration  = 0.005;

drc      = levels2drc_astrid(f_s,freqs,levels,chord_duration,ramp_duration);
waveform = gen_drc(f_s,freqs,levels,chord_duration,ramp_duration);
fprintf('error between levels2drc and waveform: %f\n',norm(drc.snd./max(abs(drc.snd))-waveform./max(abs(waveform))));
