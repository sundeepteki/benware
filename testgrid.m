% this path will be replaced in all fields of the grid where it is found
replace_path = {'E:\auditory-objects\sounds-uncalib', '~/scratch/benware.stimuli'};

% if true, play the sounds using sound()
playsounds = true;

% multiplier to adjust sounds by to make them audible
level_adjust = 10;

% if true, play the entire randomised stimulus set specified by grid.randomisedGrid
% if false, just play each stimulus once as specified by grid.stimGrid
play_complete_grid = false;

% stimulus directory for "directory of wav file" stimuli
stimulus_dir = './stimulusdir';

% no more parameters after this

loadexpt;
expt.stimulusDirectory = stimulus_dir;

grid = chooseGrid(expt.stimulusDirectory);
grid = prepareGrid(grid, expt);

% replace path
if exist('replace_path', 'var')
  from = replace_path{1};
  to = fix_slashes(replace_path{2});
  fprintf('Replacing %s with %s in grid...\n', from, to)
  from = lower(fix_slashes(from));
  len = length(from);
end

fields = fieldnames(grid);
for ii = 1:numel(fields)
  fieldname = fields{ii};
  fieldvalue = grid.(fields{ii});
  if isstr(fieldvalue) && length(fieldvalue)>=len && all(fix_slashes(fieldvalue(1:len))==from)
    fieldvalue = fix_slashes([to fieldvalue(len+1:end)]);
    fprintf('--> grid.%s is now %s\n', fieldname, fieldvalue)
    grid.(fields{ii}) = fieldvalue;
  end
end

if play_complete_grid == false
  grid.randomisedGrid = grid.stimGrid;
  grid.nSweepsDesired = size(grid.stimGrid, 1);
end

fprintf('\n\n= Expt:')
expt

fprintf('\n\n= Grid:')
grid

sweeps = struct;
for sweepNum = 1:grid.nSweepsDesired
  fprintf('= Sweep %d\n', sweepNum)
  [sweeps(sweepNum).stim, sweeps(sweepNum).stimInfo] = prepareStimulus(grid.stimGenerationFunction, ...
                                                       sweepNum, grid, expt);
  if playsounds
    sound(stim*level_adjust, grid.sampleRate)
    pause(size(stim, 2)/grid.sampleRate)
  end
end
