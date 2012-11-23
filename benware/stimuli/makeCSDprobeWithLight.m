function [stim, stimInfo] = makeCSDprobeWithLight(sweepNum, grid, expt)

stimInfo.stimGridTitles = grid.stimGridTitles;
stimInfo.stimParameters = grid.randomisedGrid(sweepNum, :);

% grid.stimGridTitles = {'Stimulus Length (ms)', 'Noise Delay (ms)', 'Noise Length (ms)', 'Light voltage (V)', 'Light delay (ms)', 'Light Duration (ms)', 'Level'};
% grid.stimGrid = [200 50 50 0 50 150 80; 200 50 50 0 50 150 80];

parameters = grid.randomisedGrid(sweepNum,1:end);

duration = ceil(parameters(1)/1000*grid.sampleRate);
delay = round(parameters(2)/1000*grid.sampleRate);
len = round(parameters(3)/1000*grid.sampleRate);
level = parameters(7);

lightvoltage = parameters(4);
lightdelay = ceil(parameters(5)/1000*grid.sampleRate);
lightduration = ceil(parameters(6)/1000*grid.sampleRate);

stimLen_samples = duration;

% sound in channel 1
uncalib = zeros(1, stimLen_samples);
uncalib(1, delay:delay+len-1) = randn(1, len); 

stim = nan(2, length(uncalib));
stim(1,:) = uncalib*10^((grid.stimLevelOffsetDB(1) + level)/20);

% light in channel 2
lightstim = zeros(1, stimLen_samples);
lightstim(1, lightdelay:min(stimLen_samples, lightdelay+lightduration-1)) = lightvoltage;

stim(2,:) = lightstim;
