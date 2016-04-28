%global REPLACE_PATH
%REPLACE_PATH = ['E:\auditory-objects\benware.stimuli', '~/scratch/benware.stimuli']

% if true, play the sounds using sound()
playsounds = true

% multiplier to adjust sounds by to make them audible
level_adjust = 10

% if true, play the entire randomised stimulus set specified by grid.randomisedGrid
% if false, just play each stimulus once as specified by grid.stimGrid
play_complete_grid = false

global TEST
TEST = true;

loadexpt;
expt.exptDir = ['./' expt.exptSubDir];
expt.dataDir = ['./' expt.exptSubDir expt.dataSubDir];
expt.stimulusDirectory = './stimulusdir';

grid = chooseGrid(expt.stimulusDirectory);
grid = prepareGrid(grid, expt);

expt
grid

if play_complete_grid == false
  grid.randomisedGrid = grid.stimGrid;
  grid.nSweepsDesired = size(grid.stimGrid, 1);
end

sweeps = struct;
for sweepNum = 4 %:grid.nSweepsDesired
  fprintf('= Sweep %d\n', sweepNum)
  [stim, sweeps(sweepNum).stimInfo] = prepareStimulus(grid.stimGenerationFunction, ...
                                                      sweepNum, grid, expt);
  if playsounds
    sound(stim*level_adjust, grid.sampleRate)
    pause(size(stim, 2)/grid.sampleRate)
  end
end