function grid = grid_dadida()

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'make_and_compensate_dadida';
  grid.sampleRate = 24414.0625*2;  % ~100kHz

  % essentials
  grid.name = 'dadida';
  
  % stimulus grid structure
  % stimseq(sampleRate,Afreq,Aamp,Bfreq,Bamp,tondur,ncycles,prestim)
  grid.stimGridTitles = {'A freq (Hz)', 'B freq (Hz)', ...
      'Tone duration (ms)', 'Number of cycles', 'Prestim Tone ID', ...
      'Number of prestim cycles', 'Prestim tone freq (Hz)', 'Level'};
  grid.stimGrid = [1000 2000 200 4 0 0 0 80; ...
                   %1000 2000 200 4 1 4 0 80; ...
                   %1000 2000 200 4 1 4 500 80; ...
                    ];
                
  % sweep parameters
  grid.postStimSilence = 0;
  grid.repeatsPerCondition = 10;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = -112;
  
  % compensation filter
  grid.initFunction = 'loadCompensationFilters';
  grid.compensationFilterFile = ...
    'e:\auditory-objects\calibration\calib.expt42\compensationFilters.mat';
  grid.compensationFilterVarNames = {'compensationFilters.L', 'compensationFilters.R'};
