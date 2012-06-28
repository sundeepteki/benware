function [stim, stimInfo] = makeCSDprobe(sweepNum, grid, expt)

stimInfo.stimGridTitles = grid.stimGridTitles;
stimInfo.stimParameters = grid.randomisedGrid(sweepNum, :);

parameters = grid.randomisedGrid(sweepNum,1:end);

duration = ceil(parameters(1)/1000*grid.sampleRate);
delay = round(parameters(2)/1000*grid.sampleRate);
len = round(parameters(3)/1000*grid.sampleRate);
level = parameters(4);

stimLen_samples = duration;

uncalib = zeros(1, stimLen_samples);
uncalib(1, delay:delay+len-1) = randn(1, len); 

stim = nan(length(grid.stimLevelOffsetDB), length(uncalib));

for ii = 1:length(grid.stimLevelOffsetDB)
	stim(ii,:) = uncalib*10^((grid.stimLevelOffsetDB(ii) + level)/20);
end
