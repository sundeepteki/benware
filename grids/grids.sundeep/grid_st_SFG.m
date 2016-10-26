function grid = grid_st_SFG()

%{

Function: Runs SFG (~MEG; Teki et al. 2016) paradigm
Usage:    grid = grid_st_SFG()
Home:     grids.sundeep (benware)

Procedure: 
- 1 block containing FIG and GND stimuli with different COH (1,2,4,6,8,10)

------------    
Sundeep Teki
v1: 12-Jul-2016 11:05:47

%}

%% required parameters

grid.seed                       = rng;
grid.sampleRate                 = tdt100k;
grid.stimGenerationFunctionName = 'stimgen_st_SFG'; 
grid.date                       = datestr(now);

%% Stimulus parameters

grid.stimGridTitles = {'Condition'};

% stimulus parameters
sfg.F0           = 150;
sfg.octave_sep   = 1/24;
sfg.freqs        = sfg.F0 * 2 .^((0:128)*sfg.octave_sep);
sfg.initLen      = 8;
sfg.midLen       = 8; 
sfg.finLen       = 0;
sfg.initCoh      = 0;
sfg.midCoh       = [1 2 4 6 8 10];
sfg.finCoh       = 0;
sfg.trialspercoh = 96;
sfg.num_trials   = sfg.trialspercoh * length(sfg.midCoh) * length(sfg.cond);

sfg.cond         = [0 1]; % 0 for GND, 1 for FIG 
sfg.num_bursts   = [sfg.initLen sfg.midLen sfg.finLen];
sfg.perc_coh     = [sfg.initCoh sfg.midCoh sfg.finCoh];
sfg.num_comp     = [10 10 10]; % number of components per chord
sfg.len_chord    = [25 25 25]; % ms
sfg.comp_min     = 5;          % minimum number of components per chord
sfg.comp_max     = 15;         % maximum number of components per chord

sfg.dur          = (sfg.initLen + sfg.midLen)*sfg.len_chord(1)/1000; % sec
sfg.level        = 65;                                          % dB
sfg.amp          = 20e-6*10.^(vowel.level/20);                  % convert to Pascals
vowel.hannramp   = 0.005;                                       % ramp size - 5ms
sfg.prestim      = 0.2;                                         % pre-stim interval; seconds
sfg.poststim     = 0.2;                                         % post-stim interval; seconds

% permutations
sfg.cond_all     = [zeros(1,sfg.trialspercoh * length(sfg.midCoh)) ones(1,sfg.trialspercoh * length(sfg.midCoh))];
sfg.cond_trials  = sfg.cond_all(randperm(length(sfg.cond_all)));
sfg.coh_fig      = tshuffle([ones(sfg.midCoh(1),sfg.trialspercoh)] 2*[ones(sfg.midCoh(1),sfg.trialspercoh)] 4*[ones(sfg.midCoh(1),sfg.trialspercoh)] ...
                   6*[ones(sfg.midCoh(1),sfg.trialspercoh)] 8*[ones(sfg.midCoh(1),sfg.trialspercoh)] 10*[ones(sfg.midCoh(1),sfg.trialspercoh)]);
sfg.coh_gnd      = tshuffle([ones(sfg.midCoh(1),sfg.trialspercoh)] 2*[ones(sfg.midCoh(1),sfg.trialspercoh)] 4*[ones(sfg.midCoh(1),sfg.trialspercoh)] ...
                   6*[ones(sfg.midCoh(1),sfg.trialspercoh)] 8*[ones(sfg.midCoh(1),sfg.trialspercoh)] 10*[ones(sfg.midCoh(1),sfg.trialspercoh)]);              
sfg.coh_all      = [sfg.coh_fig sfg.coh_gnd];


%% Specify experimental condition, animal group and testing day

grid.animal                 = input('Enter animal ID: ','s');
grid.stimGrid               = sfg.cond_trials;
grid.cohGrid                = sfg.coh_all;
grid.repeatsPerCondition    = 1; 
    
%% sweep parameters

grid.postStimSilence    = 0;  % in seconds (added in stimgen_st_SFG)
grid.sfg                = sfg;
grid.randomiseGrid      = true;
