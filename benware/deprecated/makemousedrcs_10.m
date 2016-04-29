%% make mouse drcs

% version 4 -- used for first James mouse
% version 5 -- expt 47 --- very broken; go up to 800 kHz instead of 80!
% version 6 -- switching contrast; only go up to 64kHz (unused?)
% version 7 -- for jonathan, 10 Jun 2013; 4-64kHz. also wider contrast ranges for james.
% version 8 -- for james, 5 Sep 2013; 1-64kHz, four contrasts, 25/50/100ms chords.
% version 9 -- for james, 15 Dec 2014; 1-64kHz, four contrasts, 25/50/100ms chords, 5 second duration - for wholecell.
%version 10 -- for Michael 22/11/2015< 1-64kHz, Three contrasts, 25ms
%chords, 40 second duration. And now saved in Wav format for new benware
%versions

version = 10;

savedir = sprintf('mouse.drc.%d', version);

stim.f_s = 24414.0625*8; % TDT 200K
stim.freq.min = 1000;
stim.freq.spacing = 1/4; % octaves
stim.freq.step = 2^(stim.freq.spacing);
stim.freq.n = 6*(1/stim.freq.spacing)+1;

%% get frequencies of tones
stim.freq.multipliers = 0:(stim.freq.n-1);
stim.freq.freqs = stim.freq.min*stim.freq.step.^stim.freq.multipliers;
stim.freqs = stim.freq.freqs;
fprintf('Frequency range %0.3f kHz to %0.3fkHz\n', min(stim.freqs/1000), max(stim.freqs/1000));

stim.ramp_duration = 5/1000;

stim.duration = 40; % sec
chord_durations = [25/1000]; % fast, medium and slow

n_chords = stim.duration./chord_durations;

stim.meanlevel = 40;
ranges = [30];


%% make DRCs one at a time
if ~exist(savedir, 'dir')
	mkdir(savedir);
end

if ~exist([savedir '/allinfo'], 'dir')
	mkdir([savedir '/allinfo']);
end

if ~exist([savedir '/grids'], 'dir')
	mkdir([savedir '/grids']);
end

if ~exist([savedir '/uncalib'], 'dir')
	mkdir([savedir '/uncalib']);
end


for range = ranges
	stim.range = range;

	for durIdx = 1:length(chord_durations)
		stim.chord_duration = chord_durations(durIdx);
		stim.n_chords = n_chords(durIdx);

		for token = 1:4
			rand('seed', 110876+token*997);
			stim.token = token;
			fprintf('Range %d, chord duration %d, token %d', stim.range, stim.chord_duration*1000, stim.token);

			%% make grid of levels
			stim.levels = (rand(stim.freq.n, stim.n_chords)-0.5)*stim.range+stim.meanlevel;

			%% make waveform
            stim.drc = levels2drc(stim.f_s, stim.freqs, stim.levels, ...
                stim.chord_duration, stim.ramp_duration);
                stim.drc.snd= stim.drc.snd*(0.1995/0.0225); %Correct sound so it 1.0 rms is equal to 94dB
     
			%% save
			savename = sprintf('drc%d_dur%d_contrast%d', ...
					stim.token, stim.chord_duration*1000, stim.range);
			save([savedir '/allinfo/' savename '.mat'], 'stim');

			grid.freqs = stim.freqs;
			grid.levels = stim.levels;
			grid.chord_duration = stim.chord_duration;

			%% save minimal info in grids
			save([savedir '/grids/' savename '.mat'], 'stim');

			%% write waveform
			wavwrite(stim.drc.snd,stim.f_s, [savedir '/uncalib/' savename '.wav']);

			fprintf('\n');

		end
	end
end
