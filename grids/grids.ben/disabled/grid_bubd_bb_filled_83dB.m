function grid = grid_bubd_bb_filled_83dB()

%% BUBD filled and controls

  % controlling the sound presentation
  grid.stimGenerationFunctionName = 'loadStereo';
  grid.stimDir = 'E:\auditory-objects\sounds.calib.expt%E\bubd_bb_filled\';
  grid.sampleRate = 24414.0625*2;  % ~50kHz

  % essentials
  grid.name = 'bubd_bb_filled.83dB';
%   grid.stimFilename = 'bubd_bb.id.%1.token.%2.%L.f32';
  grid.stimFilename = 'bubd_bb_filled.id.%1.token.%2.%L.f32';
  
  % stimulus grid structure
  grid.stimGridTitles = {'ID', 'Token', 'Level'};
%   grid.stimGrid = sortrows(combvec([801:884 886:890 892:899], 1:20, 83)');
  grid.stimGrid = sortrows(combvec([901:1000], 1:20, 83)');
  
  % sweep parameters
  grid.sweepLength = 2.1; % seconds
  grid.repeatsPerCondition = 1;
  
  % set this using absolute calibration
  grid.stimLevelOffsetDB = [-123,-122.5];
  
  
%   %% A SHORTER VERSION OF THE ABOVE -- no nPulses=3 'classic' included
%   
%   % controlling the sound presentation
%   grid.stimGenerationFunctionName = 'loadStereo';
%   grid.stimDir = 'E:\auditory-objects\sounds.calib.expt%E\bubd_bb_filled\';
%   grid.sampleRate = 24414.0625*2;  % ~50kHz
% 
%   % essentials
%   grid.name = 'bubd_bb_filled.83dB';
% %   grid.stimFilename = 'bubd_bb.id.%1.token.%2.%L.f32';
%   grid.stimFilename = 'bubd_bb_filled.id.%1.token.%2.%L.f32';
%   
%   % stimulus grid structure
%   grid.stimGridTitles = {'ID', 'Token', 'Level'};
% %   grid.stimGrid = sortrows(combvec([801:884 886:890 892:899], 1:20, 83)');
%   grid.stimGrid = sortrows(combvec([901:956 957:2:987 989,991,992,994,995,997,998,1000], 1:20, 83)');
%   
%   % sweep parameters
%   grid.sweepLength = 2.1; % seconds
%   grid.repeatsPerCondition = 1;
%   
%   % set this using absolute calibration
%   grid.stimLevelOffsetDB = [-128,-129.5];
  
  
%  %% BUBD classic and controls from 800 series (=bb) but without ITD=[63,79]
% 
%   % controlling the sound presentation
%   grid.stimGenerationFunctionName = 'loadStereo';
%   grid.stimDir = 'E:\auditory-objects\sounds.calib.expt%E\bubd_bb\';
%   grid.sampleRate = 24414.0625*2;  % ~50kHz
% 
%   % essentials
%   grid.name = 'bubd_bb.83dB';
% %   grid.stimFilename = 'bubd_bb.id.%1.token.%2.%L.f32';
%   grid.stimFilename = 'bubd_bb.id.%1.token.%2.%L.f32';
%   
%   % stimulus grid structure
%   grid.stimGridTitles = {'ID', 'Token', 'Level'};
%   grid.stimGrid = sortrows(combvec([807:830 844:866 873:884 886:890 892:899], 1:20, 83)');
%   
%   % sweep parameters
%   grid.sweepLength = 2.2; % seconds
%   grid.repeatsPerCondition = 1;
%   
%   % set this using absolute calibration
%   grid.stimLevelOffsetDB = [-128,-129.5]; 