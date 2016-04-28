function grid = grid_monosearchnoise200k()

  % controlling the sound presentation
  grid.sampleRate = tdt200k;
  grid.stimGenerationFunctionName = 'stimgen_CSDProbeWithLight';
  
  % stimulus grid structure
  %grid.stimGridTitles = {'Stimulus Length (ms)', 'Delay (ms)'; 'Noise Length (ms)', 'Level'};
  %grid.stimGrid = [250 50 50 80];

  % stimulus grid structure
  grid.stimGridTitles = {'Stimulus Length (ms)', 'Noise Delay (ms)', ...
           'Noise Length (ms)', 'Light voltage (V)', 'Light delay (ms)', 'Light Duration (ms)', 'Level'};
  %grid.stimGrid = [1000 250 50 8 0.01 750 80; 1000 250 50 0 0.01 750 80;];
  grid.stimGrid = [250 50 50 0 0.01 0 80];  
  
  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = Inf;
  grid.saveWaveforms = false;
