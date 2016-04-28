function [stim, stimInfo] = randomStim(sweepNum, grid, expt)

stimInfo.sweepNum = sweepNum;
stimInfo.stimGridTitles = grid.stimGridTitles;
stimInfo.stimParameters = grid.randomisedGrid(sweepNum,:);
stim = rand(2,ceil(stimInfo.stimParameters(1)*grid.sampleRate/1000));
