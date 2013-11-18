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
chord_duration = 0.050;
ramp_duration  = 0.010;
complex        = 200:200:20000;
n_chord        = 100;
jitter         = 0.001;           % in percent
levels_offset  = 40;              % mean 50 dB with range [45,55] (=0..10+40) dB
levels_range   = 10;              % mean 50 dB with range [45,55] (=0..10+40) dB
