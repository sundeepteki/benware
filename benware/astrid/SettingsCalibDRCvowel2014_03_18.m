% settings file that defines Astrid's morphed vowel stimuli in a changing DRC (dynamic random chord) background and
% saves them into a struct for BenWare(TM)
%
% 1 Nov 2013 - first version (astrid)
% 

settings_parser   = 'CalibrationDRCVowel';         % use specialized parsers to allow short setting files
[status,hostname] = system('hostname');          % get name of host benware is currently running on
switch strtrim(hostname)
    case {'ATWSN647','schleppi'}
        logfile_directory = '';
    otherwise
        logfile_directory = 'E:\auditory-objects\astrid\Stimuli\';
end
fs             = 24414.0625*4;    % ~100kHz, the maximal sampling frequency of TDT Sigma Delta D/A converter

% DRC settings
chord_duration = 0.050;           % in sec
ramp_duration  = 0.010;           % in sec
complex        = 200:200:20000;   % frequency components of complex
n_chord        = 80;              % number of chords, n_chord*chord_duration should equal about 4 sec overall stimulus length per jitter condition (Dahmen et al. 10 used 5s but said that for adaptation only a few 100ms are sufficient)
jitter         = 0.001;           % random frequency jitter in percent
levels_offset  = 50;              % mean level for each frequency component, e.g. 45 offset plus 10 range = mean of 50 dB with range [45,55] (=0..10+45) dB 
levels_range   = 0;              % mean 50 dB with range [45,55] (=0..10+45) dB for each frequency component
