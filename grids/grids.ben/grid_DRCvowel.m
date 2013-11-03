function grid = grid_DRCvowel()
% grid_DRCvowel() -- defines Astrid's vowel + DRC stimuli
%   Usage: 
%      grid  = grid_DRCvowel()
%   Outputs:
%      grid    return a benware(TM) grid with Astrid's vowel + DRC 
%
% Author: stef@nstrahl.de
% Version: $Id:$

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
grid.stimGenerationFunctionName = 'getStimFromStructAstrid';

calibration = false;
if calibration
  fprintf('For calibration only!');
  pause;
  settingsFile = 'E:\auditory-objects\benware\benware\astrid\SettingsCalibDRCvowel2013_11_04.m';
else
  settingsFile = 'E:\auditory-objects\benware\benware\astrid\SettingsDRCvowel2013_11_04.m';    
end

fprintf('Generating stimuli...\n');
grid.stimuli = createExperimentStimuli(settingsFile, compensationFilterFile);
grid.stimGridTitles = {'Stim set', 'Level'};

if calibration
    grid.stimGrid = createPermutationGrid(1, 80); % calibration will be done at 80dB SPL
else
    grid.stimGrid = createPermutationGrid(1:length(grid.stimuli), 80); % correct level will be handled within createExperimentStimuli()
end

% set this using absolute calibration
%grid.stimLevelOffsetDB = [0 0]-25; % can the two identical values be replaced by
grid.stimLevelOffsetDB = -16;      % just one scalar value?

% sweep parameters
grid.postStimSilence = 0;         % no need of silence between stimulus sets, WAV files have trailing inter stimulus interval
grid.repeatsPerCondition = 1;     % we need permutation between stimuli so it is done within the WAV files
