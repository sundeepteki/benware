function stim = CreateAstridStimuli(settingsfile,compensationfilterfile,seed)
% CreateAstridStimuli() -- generates experiment stimuli as defined by settings
%   Usage:
%      err = CreateAstridStimuli(settingsfile,compensationfilterfile,seed)
%   Parameters:
%      settingsfile                     this file contains the Settings defining the experiment
%      compensationfilterfile           this file contains the two compensation filters (compensationfilter(1,:) is left, compensationfilter(2,:) is right) [optional]
%      seed                             specific random seed to be used [optional]
%   Outputs:
%      stim        struct containing sound stimuli (stim(1).L,stim(1).R,stim(2).L,stim(2).R,...)
%
% Author: stef@nstrahl.de, astrid.klinge-strahl@dpag.ox.ac.uk
% Version: $Id: CreateAstridStimuli.m 153 2014-04-12 11:31:36Z stefan $

dostimplot = false;
stim = [];
t    = clock;                                    % get current time as vector [year month day hour minute seconds]
if ~exist('seed','var')                          % if we didn't get a specific random seed
    seed = round(sum(100*t));                    % generate new random number dependent on current time and make it an integer seed to remember it better
end
rand('twister', seed);                           % use Mersenne Twister pseudo-random number generator

if isempty(settingsfile)                         % if we are called within benware this will be empty and we ask online for the name
    settingsfile_default = sprintf('SettingsMistuned%d_%02.0f_%02.0f.m',t(1),t(2),t(3));
    settingsfile = input(['Please enter the name of the settings file if [' settingsfile_default '] is not correct, else <return>: ']);
    if isempty(settingsfile)                     % did we get just a return then use the offered default
        settingsfile = settingsfile_default;
    end
end
fprintf('Loading settings from %s...\n',settingsfile);

complex = []; % Matlab WTF - otherwise tries to call complex() from toolbox???
freqs = []; % Matlab WTF 2nd

run(settingsfile);                               % load settings

logfilename = sprintf('%d-%02.0f-%02.0f_%02.0f-%02.0f-%02.0f_CreateAstridStimuli_%s.log',t(1),t(2),t(3),t(4),t(5),t(6),settings_parser);
matfilename = sprintf('%d-%02.0f-%02.0f_%02.0f-%02.0f-%02.0f_CreateAstridStimuli_%s.mat',t(1),t(2),t(3),t(4),t(5),t(6),settings_parser);
fid = fopen([logfile_directory logfilename],'a');  % open logfile in assigned directory
fprintf(fid,'%d-%02.0f-%02.0f %02.0f:%02.0f:%02.0f - CreateAstridStimuli started using %s\n',t(1),t(2),t(3),t(4),t(5),t(6),settingsfile);
fprintf(fid,'  random_seed = %1.0f;\n',seed);      % store which random seed was used

eval(['CreateAstridStimuli_' settings_parser]);   % assume that we can call a Matlab script CreateAstridStimuli<settings_parser>.m to do the Stimulus specific task
fclose(fid);

end % function CreateAstridStimuli

function [norm_left, norm_right,freq_bins_left,freq_bins_right] = get_normalized_compensations(compensationfilterfile)

load(compensationfilterfile);                       % get inverse filter as impulse response
% log individual compensation levels
% To get an amplitude correction factor, Aamp, for frequency Afreq:

% get impulse response of compensation filter for left and right channel
left_IR  = compensationFilters.L;
right_IR = compensationFilters.R;

% get power spectrum of compensation filter
left_fourier  = abs(fft(left_IR));
right_fourier = abs(fft(right_IR));
left_fourier  = left_fourier(1:length(left_fourier)/2);
right_fourier = right_fourier(1:length(right_fourier)/2);

% get frequencies corresponding to power spectrum
%freq_bins_left  = linspace(0, grid.sampleRate/2, length(left_fourier));
%freq_bins_right = linspace(0, grid.sampleRate/2, length(right_fourier));
freq_bins_left  = linspace(0, 100000/2, length(left_fourier));
freq_bins_right = linspace(0, 100000/2, length(right_fourier));

% find maximal attenuation value of speaker in frequency region
% of interest and normalize
max_filtervalue_left = max(left_fourier(freq_bins_left<25e3));
max_filtervalue_right = max(right_fourier(freq_bins_right<25e3));
norm_left = left_fourier/max_filtervalue_left;
norm_right = right_fourier/max_filtervalue_right;

end