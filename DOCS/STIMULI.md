## Stimuli
version: 03-May-2016 17:27:47

There are two ways to define stimuli in Benware:

* providing a directory of .wav or .f32 files. These can't easily change from experiment to experiment.
* providing grid_ and stimgen_ functions which generate stimuli on the fly.


### Directory of wav/f32 files:

1. Make wav or 32-bit floating point files (extension .f32) containing your
stimuli. Take note of the following important constraints:

    1. Your wav files must have a TDT supported sample rate (eg. 48828 or 97656
    Hz).

    2. All wav files in a given directory must have the same sample rate.

    3. The values in your wav files will be interpreted as pressures in Pascals.
    This means that, if you make a 1kHz tone in Matlab, with an RMS of 1, it will
    be played at 1 Pascal RMS, I.E. 94dB.

    4. You should be careful about the calibrated range of the equipment.
    Currently, this means that at 48828Hz, your stimuli should contain only
    frequencies between 200 and 22kHz, and at 97656Hz, your stimuli should contain
    only frequencies between 200 and 32kHz. If your stimulus contains frequencies
    outside this range, they will be attenuated by the equipment, and so the
    overall level of your sounds will be lower than you expect.

    5. The maximum length of your wav files should be 40 seconds.  F: If
    you want the same stimulus in both ears, use mono wav files. If you want
    different stimuli in the two ears, use stereo wav files.

2. Put your sound files in a directory. The name of this directory is what
benware will call your stimulus

3. Optionally, add a file ‘parameters.txt’ inside your directory. This can
contain many different parameters, but the ones you are likely to need are:
```
reps = 10     # (the number of times your stimulus is repeated; defaults to 20)
sampleRate = 48828     # (only necessary for .f32 files)
```

### grid_ and stimgen_ functions

The grid_ function lives in benware/grids/grids.username. This directory will
be scanned by Benware, and all files matching grid_*.m will be treated as
grid functions. Each grid function defines one set of stimuli. See grid_quning.m,
grid_csdprobe.m, grid_bilateral_noise.m and grid_texture_v4.m for examples.

#### grid_function

Defined as:
```
function grid = grid_function()
```

Called by prepareGrid.m as:
```
grid = grid_function()
```

Grid functions must obey the following rules:

1. The name must be 'grid_', and the name at the top of this file must
     match the filename.
     
2. Must return a grid structure containing the fields:
```
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
```

The stimulus generation function will be called by BenWare to generate
each stimulus as:
```
uncomp = stimgen_function(expt, grid, parameters{:})
```
Any extra fields you put in the grid will be saved by Benware when your
stimuli are presented, so you can refer to them later.

#### stimgen_function

Defined as:
```
function stim = stimgen_function(expt,grid,varargin)
```

The stimulus generation function will be called by prepareStimulus.m as:
```
uncomp = stimgen_function(expt, grid, parameters{:})
```
where 'parameters' is a row from grid.stimGrid, so the parameters are values
of the stimulus parameters specified in grid.stimGridTitles.

Stimulus generation functions must obey the following rules:

1. Must have a name that begins stimgen_*
2. Accept parameters:

    1. expt: standard benware expt structure (as loaded by loadexpt.m)
    2. grid: standard benware grid structure (produced by grid_*.m)
    3. varargin: a list of parameters, whose length matches the length of grid.stimGridTitles

3. Produces a matrix containing uncalibrated sound, meeting these criteria:
    1. The sample rate must match grid.sampleRate
    2. The first dimension of this matrix must match expt.nStimChannels.
    3. The values are measured in Pascals, so that a sound with an RMS of 1
        corresponds to 1 Pascal RMS, or 94 dB SPL.
            
Calibration is now performed by Benware; internal calibration is not required.


### Testing

To test your stimuli, try:
```testgrid.m
```
It allows you to choose a grid and then runs through a fake benware experiment, using exactly the same code as the real benware. It spits out both the uncalibrated sounds produced by your stimulus grid, and the actual calibrated stimulus values that would be sent to the TDT hardware. It optionally plays the uncalibrated versions through the computers’ speakers.
