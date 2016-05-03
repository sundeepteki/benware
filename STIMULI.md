# Stimuli
version: 03-May-2016 17:27:47

Defining your stimuli in Benware is now straightforward. Two basic functions are required: one to define the grid, and another, to define the stimulus.
  
    
### grid_function

    % defined as function grid = grid_function()
    % called by prepareGrid.m as grid = grid_function()
        
    Grid functions must obey the following rules:
    1. The name must be 'grid_', and the name at the top of this file must
         match the filename.
         
    2. Must return a grid structure containing the fields:
         grid.sampleRate: stimulus sample rate (e.g. tdt100k)
         grid.stimGenerationFunctionName: name of a stimulus generation function
         grid.stimGridTitles: a cell containing the names of stimulus parameters
         grid.stimGrid: a matrix specifying values of the parameters in
           grid.stimGridTitles, one stimulus per row. The number of columns must 
           match the length of grid.stimGridTitles
         grid.repeatsPerCondition: integer specifying how many times the 
                                   grid will be repeated
         grid.postStimSilence: number specifying the inter-stimulus interval  
           (set value in seconds here, or incorporate ISI in stimgen_function) 
           
     The stimulus generation function will be called by BenWare to generate
     each stimulus as 
     uncomp = stimgen_function(expt, grid, parameters{:})

    
    
   
    
### stimgen_function

    % defined as function stim = stimgen_function(expt,grid,varargin)

	The stimulus generation function will be called by prepareStimulus.m as:
	  uncomp = stimgen_function(expt, grid, parameters{:})
	where 'parameters' is a row from grid.stimGrid, so the parameters are values
	of the stimulus parameters specified in grid.stimGridTitles.
	
	Stimulus generation functions must obey the following rules:
	1. Must have a name that begins stimgen_*
	2. Accept parameters:
	     expt: standard benware expt structure (as loaded by loadexpt.m)
	     grid: standard benware grid structure (produced by grid_*.m)
	     varargin: a list of parameters, whose length matches
	               the length of grid.stimGridTitles
	3. Produces a matrix containing uncalibrated sound, meeting these criteria:
	     A. The sample rate must match grid.sampleRate
	     B. The first dimension of this matrix must match expt.nStimChannels.
	     C. The values are measured in Pascals, so that a sound with an RMS of 1
	        corresponds to 1 Pascal RMS, or 94 dB SPL.
            
    % Calibration is now performed by Benware; internal calibration is not required.
    
    % To test your stimuli, try 'testgrid.m'. It allows you to choose a grid and then runs through a fake benware experiment, using exactly the same code as the real benware. It spits out the stimulus values that would be sent to the TDT hardware, and optionally plays them through the computers’ speakers. Remember that these are compensated for the frequency response of your rig speaker (not the computer speaker), so they may sound a bit odd.
    