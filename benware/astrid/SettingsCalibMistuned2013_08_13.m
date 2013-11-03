% settings file that defines Astrid's mistuned harmonics stimuli and
% saves them into seperate WAV files for BenWare(TM)
%
% 10 Aug 2013 - first version (astrid)

settings_parser   = 'CalibrationMistuned';       % use specialized parsers to allow short setting files
idname            = ['Astrid_' settings_parser]; % unique identifier for stimulus sets generated with this setting file
logfile_directory = '.';

frequency       = 800;                  % frequency of calibration pure tone (Hz)
stim_length     = 5;                    % stimulus length (sec)
level           = 80;                   % stimulus level (dB SPL)

fs              = 24414.0625*4;         % ~100kHz, the maximal sampling frequency of TDT Sigma Delta D/A converter
bits            = 16;                   % we use 16 bit wavs for inspection