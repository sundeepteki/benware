% settings file that defines Astrid's mistuned harmonics stimuli and
% saves them into seperate WAV files for BenWare(TM)
%
% Version: $Id:$

settings_parser   = 'CalibrationMistuned';  % use specialized parsers to allow short setting files
% logfile_directory = 'E:\auditory-objects\astrid\Stimuli\';
logfile_directory = '';
frequency         = 1000;                 % frequency of calibration pure tone (Hz)
stim_length       = 5;                    % stimulus length (sec)
level             = 80;                   % calibrate at 80 dB SPL (amp = 0.2 Pascal)
fs                = 24414.0625*4;         % ~100kHz, the maximal sampling frequency of TDT Sigma Delta D/A converter
