% settings file that defines Astrid's morphed vowel stimuli in a changing DRC (dynamic random chord) background and
% saves them into a struct for BenWare(TM)
%
% 1 Nov 2013 - first version (astrid)
% 

settings_parser   = 'DRCvowel';                    % use specialized parsers to allow short setting files
[status,hostname] = system('hostname');          % get name of host benware is currently running on
switch strtrim(hostname)
    case {'ATWSN647','schleppi'}
        logfile_directory = '';
    otherwise
        logfile_directory = 'E:\auditory-objects\astrid\Stimuli\';
end

% repetitions     = 15;                    % how often a unique stimulus set shall be repeated while being permutated
% ^^^-- this needs to be set in grid_DRCvowel.m last line (grid.repeatsPerCondition)

fs              = 24414.0625*4;         % ~100kHz, the maximal sampling frequency of TDT Sigma Delta D/A converter

%vowel settings (stimlen,fs,f0,formants,bandwidths,carriertype,hannramp)
vowel_dur       = 0.2;                  % duration of vowel (sec)
f0              = 220;                  % fundamental frequency of vowel (Hz) (one example of voice pitches in Hillenbrand et al. 1995, JASA 97)
startvowel      = [460 1105 2735 4052]; % formant frequencies f1, f2, f3, f4 (Hz) for vowel: [460; 1105; 2735; 4052] is vowel /u/ (same freqs as used by Bizley et al. 2013 JASA, ref. to Kewley-Port et al. 1996, Kewley-Port et al. 1994, Peterson et al. 1952)
endvowel        = [730 2058 2979 4294]; % formant frequencies f1, f2, f3, f4 (Hz) for vowel: [730; 2058; 2979; 4294] is vowel /epsilon/
nsteps          = 2;                    % number of steps for 'morphing' startvowel into endvowel (incl. formants of start- and endvowel)
formants        = [linspace(startvowel(1),endvowel(1),nsteps);...
                   linspace(startvowel(2),endvowel(2),nsteps);...
                   linspace(startvowel(3),endvowel(3),nsteps);...
                   linspace(startvowel(4),endvowel(4),nsteps)];      % 
bandwidths      = [80 70 160 300];      % bandwidths of each formant (Hz) (from newMakeVowel.m)
carriertype     = 'clicktrain';         % what carrier, choose between 'harmonic complex' and 'clicktrain'
vowel_level     = 80;                   % vowel level in dB (relates to mean level of DRCs)(masking in noise see Bizley et al. 2013 JASA) chose 4dB below overall level of DRC (result of worst ferret)
vowel_position  = [3 7 16];             % position of the vowel after first switch in background DRC (chord number after switch) [3 7 16]

% DRC settings
chord_duration = 0.05;                  % 50 ms because then the time steps for realizing jitter switch are smaller, better for vowel_position
ramp_duration  = 0.010;
complex        = 200:200:20000;
n_chord        = 80;                   % number of chords, n_chord*chord_duration should equal about 4 sec overall stimulus length per jitter condition (Dahmen et al. 10 used 5s but said that for adaptation only a few 100ms are sufficient)
jitter         = [0.001 0.001; 0.001 0.04; 0.04 0.001; 0.04 0.04];       % frequency jitter in percent of frequency
levels_offset  = 50;                   % mean level for each frequency component, e.g. 45 offset plus 10 range = mean of 50 dB with range [45,55] (=0..10+45) dB, overall level 50 dB, 100 components is about 71dB
levels_range   = 10;                   % mean 50 dB with range [45,55] (=0..10+45) dB
