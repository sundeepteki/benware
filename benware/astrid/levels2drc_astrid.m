function drc = levels2drc(f_s, freqs, levels, chord_duration, ramp_duration)
% function drc = levels2drc(f_s, freqs, levels, chord_duration, ramp_duration)
% 
% Create a DRC waveform from a grid of levels.
% Inputs:
% f_s - sample rate
% freqs - the frequencies of the tones to use
% grid of levels - n_freqs x n_chords
% chord_duration - in seconds
% ramp_duration - in seconds
%
% Output:
% drc - structure containing waveform as drc.snd and other information
%
% Differences between this and the last version (very similar to Neil's classic DRCs)
% * at every transition (inc start/end), there is a cosine ramp in amplitude, not level
% * the first chord is the same as others
% * the end is slightly different

drc.f_s = f_s;
drc.freqs = freqs;
drc.levels = levels;
drc.chord_duration = chord_duration;
drc.ramp_duration = ramp_duration;
drc.n_chords = size(drc.levels, 2);
drc.n_freqs = size(drc.levels, 1);

%% list of samples on which chords will start
drc.chord_start_times = (0:drc.n_chords)*drc.chord_duration;
drc.chord_start_samples = round(drc.chord_start_times*drc.f_s)+1;

%% make a standard envelope for a single chord (ramp up then hold)
drc.ramp_samples = round(drc.ramp_duration .* drc.f_s);
rt = linspace(-pi/2, pi/2, drc.ramp_samples);
cosramp = sin(rt)/2+0.5;
max_chordlen = max(diff(drc.chord_start_samples));
chord_env = [cosramp ones(1, max_chordlen-drc.ramp_samples)];

%% time vector for whole stimulus
drc.total_samples = max(drc.chord_start_samples)-1 + drc.ramp_samples;
drc.t = (0:(drc.total_samples-1))/drc.f_s;

%% convert level to amplitude
drc.amplitudes = 10.^(drc.levels/20);

%% build up stimulus, one tone at a time
snd = [];

for freq_idx = 1:drc.n_freqs
	fprintf('.');

	% make carrier sinusoid
	if isvector(drc.freqs)
        freq = drc.freqs(freq_idx);
        carrier = sin(2*pi*freq*drc.t);
    else
        temp = repmat(drc.freqs(freq_idx,:),[max_chordlen 1]);
        freq = temp(:)';
        freq = horzcat(freq(1)*ones(1,length(cosramp)/2),freq,freq(end)*ones(1,length(cosramp)/2));
              
        pos           = [0 ramp_duration/2*ones(1,drc.n_chords)] + (0:(drc.n_chords))*chord_duration;   % get positions in seconds where frequency changes
        phase_diff    = -2*pi* [0 diff(drc.freqs(freq_idx,:))] .* pos(1:end-1);                         % get phase offsets/jumps to remove
        phase_correct = [0 cumsum(phase_diff(1:end-1))];                                                % we need to propagate our phase corrections
        
        temp = repmat(phase_diff+phase_correct,[max_chordlen 1]);
        phi  = temp(:)';
        phi  = horzcat(phi(1)*ones(1,length(cosramp)/2),phi,phi(end)*ones(1,length(cosramp)/2));
        
        carrier = sin(2*pi*freq.*drc.t+phi);
    end

	% make envelope
	env = {};

	last_level = 0;

	% ramp from the last amplitude
	% to the current one, then hold at the current amplitude

	for chord_idx = 1:drc.n_chords
		level = drc.amplitudes(freq_idx, chord_idx);
		len = drc.chord_start_samples(chord_idx+1) - drc.chord_start_samples(chord_idx);

		env{chord_idx} = last_level+chord_env(1:len)*(level-last_level);
		last_level = level;
	end

	% final ramp down to zero
	level = 0;
	env{end+1} = last_level+cosramp*(level-last_level);

	env = cell2mat(env);

	% superpose the frequency channels on one another to
	% get a single sound vector
	if isempty(snd)
		snd = carrier .* env;
	else
		snd = snd + carrier .* env;
	end

end

drc.example_envelope = env;

drc.snd = snd/10000;
