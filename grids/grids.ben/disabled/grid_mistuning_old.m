function grid = grid_mistuning()
% grid_mistunings() -- defines Astrid's mistuning stimuli
%   Usage: 
%      grid  = grid_mistunings()
%   Outputs:
%      grid    return a benware(TM) grid with Astrid's mistuning stimuli permuted over the desired iterations
%
% Author: stef@nstrahl.de
% Version: $Id: grid_mistunings.m 109 2013-08-12 00:20:42Z stefan $

[status,hostname] = system('hostname');          % get name of host benware is currently running on

switch strtrim(hostname)
    case {'ATWSN647','schleppi'}
        compensationFilterFile = '../calibration/compensationFilters.100k.mat';
    case 'ben'
        compensationFilterFile = '/Users/ben/scratch/expt.42/calib.expt42/compensationFilters100k.mat';
    otherwise
        compensationFilterFile = 'e:\auditory-objects\calibration\calib.ben.2013.04.27\compensationFilters.100k.mat';
end

% controlling the sound presentation
grid.sampleRate                 = 24414.0625*4;  % ~100kHz, a sampling frequency the TDT System 3 Sigma Delta D/A converter can do
% NB stimulus generation program must match this sample rate value
grid.stimGenerationFunctionName = 'getStimFromStruct';

calibration = false;
if calibration
  fprintf('For calibration only!');
  pause;
  settingsFile = 'E:\auditory-objects\benware\benware\astrid\SettingsCalibration2013_11_04.m';
else
  settingsFile = 'E:\auditory-objects\benware\benware\astrid\SettingsMistuned2013_11_04.m';    
end

fprintf('Generating stimuli...\n');
grid.stimuli = createMistuningStimuli(settingsFile, compensationFilterFile);
grid.stimuli = [grid.stimuli{:}];

% stimulus grid structure
% TODO: get automatically how many stim wav files,at the moment it needs to be edited manually

% NOTE: level parameter will do "level_offset = level - 80; stim = stim * 10^(level_offset / 20)";
% TODO: ask Ben if this is the program logic that achieves level calibration by assuming "20*log10(sqrt(var(wav))./20e-6) == 80 (dB SPL)"
grid.stimGridTitles = {'Stim set', 'Level'};

if calibration
    grid.stimGrid = createPermutationGrid(1, 80); % calibration will be done at 80dB SPL
else
    grid.stimGrid = createPermutationGrid(1:length(grid.stimuli), 60); % each harmonic component will be played at 60dB SPL
end

% set this using absolute calibration
% stefan_note: this is used in "prepareStimulus.m" doing "stim = stim * 10^(grid.stimLevelOffsetDB / 20)"
% TODO: ask Ben if I understood it correctly and we need only one scalar value and no 2x1
%grid.stimLevelOffsetDB = [0 0]-25; % can the two identical values be replaced by
grid.stimLevelOffsetDB = -16;      % just one scalar value?

% sweep parameters
grid.postStimSilence = 0;         % no need of silence between stimulus sets, WAV files have trailing inter stimulus interval
grid.repeatsPerCondition = 1;     % we need permutation between stimuli so it is done within the WAV files
