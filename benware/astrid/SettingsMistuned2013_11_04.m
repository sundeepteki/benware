% settings file that defines Astrid's mistuned harmonics stimuli and
% saves them into seperate WAV files for BenWare(TM)
%
% 10 Aug 2013 - first version (astrid)

settings_parser = 'Mistuning';                   % use specialized parsers to allow short setting files
% logfile_directory = 'E:\auditory-objects\astrid\Stimuli\';
logfile_directory = '';

repetitions     = 15;                            % how often a unique stimulus set shall be repeated while being permutated
stim_length     = 0.4;                           % stimulus length (sec)
ISI             = 1-stim_length;                 % inter stimulus interval (sec) - this realized 1 Hz presentation rate

%                  #1   #2   #3
F0s             = [800; 400; 200];      % fundamental frequencies of each stimulus (Hz)
nharmonics      = [ 12;  16;  48];      % number of harmonics of each F0
level           = 60;                   % level in dB SPL

mistuned{1}     = [2 8];                % which components of F0 #1 to mistune
mistuned{2}     = 4;                    % which components of F0 #2 to mistune
mistuned{3}     = [8 32];               % which components of F0 #3 to mistune

freqshift       = [0 1 10 50];          % all components get the same mistunings (Hz)

dopermute       = true;                 % shall I permute stimuli within a set?
fs              = 24414.0625*4;         % ~100kHz, the maximal sampling frequency of TDT Sigma Delta D/A converter
