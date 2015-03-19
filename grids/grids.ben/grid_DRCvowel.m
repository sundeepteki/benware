function grid = grid_DRCvowel()
% grid_DRCvowel() -- defines Astrid's vowel + DRC stimuli
%   Usage: 
%      grid  = grid_DRCvowel()
%   Outputs:
%      grid    return a benware(TM) grid with Astrid's vowel + DRC 
%
% Author: stef@nstrahl.de
% Version: $Id$

[status,hostname] = system('hostname');          % get name of host benware is currently running on

% Internal calibration not needed anymore (since 16/03/2014) as it will be done by Benware
% switch strtrim(hostname)
%     case {'ATWSN647','schleppi'}
%         compensationFilterFile = '../calibration_new/2014-06-13-2mm-gap/compensationFilters.mat';
%     case 'ben'
%         compensationFilterFile = '/Users/ben/scratch/expt.42/calib.expt42/compensationFilters100k.mat';
%     otherwise
%         compensationFilterFile = ...
%               'e:\auditory-objects\calibration_new\2014-06-13-2mm-gap/compensationFilters.mat';
% end

% controlling the sound presentation
grid.sampleRate                 = 24414.0625*4;  % ~100kHz, a sampling frequency the TDT System 3 Sigma Delta D/A converter can do
% NB stimulus generation program must match this sample rate value
grid.stimGenerationFunctionName = 'getStimFromStructAstrid';

global CALIBRATE;
if CALIBRATE
  fprintf('For calibration only!');
  pause;
  settingsFile = 'E:\auditory-objects\benware\benware\astrid\SettingsCalibDRCvowel2014_10_28.m';
else
  settingsFile = 'E:\auditory-objects\benware\benware\astrid\SettingsDRCvowel2015_02_03.m';    
end

fprintf('Generating stimuli...\n');
grid.stimuli = CreateAstridStimuli(settingsFile);         % ATTENTION: no compensationFilterFile needed internally, is done externally by benware
grid.stimGridTitles = {'Stim set'};

if CALIBRATE
    grid.stimGrid = createPermutationGrid(1); % calibration will be done at 80dB SPL
else
    grid.stimGrid = createPermutationGrid(1:length(grid.stimuli)); % correct level will be handled within CreateAstridStimuli()
end

% set this using absolute calibration (old way of calibrating, new since 16/03/14)
% grid.stimLevelOffsetDB = -16-7+5;      % by how much should stimulus level be adjusted

% sweep parameters
grid.postStimSilence = 0;         % no need of silence between stimulus sets, WAV files have trailing inter stimulus interval
grid.repeatsPerCondition = 15;     % we need permutation between stimuli so it is done within the WAV files
