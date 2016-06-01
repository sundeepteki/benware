function grid = grid_st_vowelsequence_1B()

%{
   
The grid function will be called (by prepareGrid) as: grid = grid_st_vowelsequence_1B()
    
    

Sundeep Teki
v1: 20.05.16

%}


%% required parameters

grid.seed                       = rng;
grid.sampleRate                 = tdt100k;
grid.stimGenerationFunctionName = 'stimgen_st_vowelsequence_1B';
grid.date                       = datestr(now);

%% Stimulus parameters

grid.stimGridTitles = {'Frequency of vowel 1','Frequency of vowel 2','Frequency of vowel 3','Frequency of vowel 4'};

% stimulus parameters
vowel.F0         = 125; % Hz
vowel.order      = [2 0 3 1];
vowel.timbre     = 'a';

if(strcmpi(vowel.timbre,'a'))
    vowel.formants   = [936 1551 2815 4290];            % for vowel a
elseif(strcmpi(vowel.timbre,'e'))
    vowel.formants   = [730 2058 2979 4294];            % for vowel e
elseif(strcmpi(vowel.timbre,'i'))
    vowel.formants   = [437 2761 3372 4352];            % for vowel i
elseif(strcmpi(vowel.timbre,'u'))
    vowel.formants   = [460 1105 2735 4115];            % for vowel u
elseif(strcmpi(vowel.timbre,'test'))
    vowel.formants   = [1350 2384 3724 4012];           % for testing purposes only
end

vowel.octavesep  = 0.75;
vowel.freqs      = floor(vowel.F0*2.^(vowel.octavesep.*vowel.order)); % [353 125 594 210]; for experiment 1A only
vowel.bandwidth  = [80 70 160 300];                 % Hz, constant for each vowel
vowel.level      = 65;                              % dB
vowel.amp        = 20e-6*10.^(vowel.level/20);      % convert to Pascals
vowel.carrier    = 'clicktrain';
vowel.hannramp   = 0.005;                           % ramp size - 5ms
vowel.preisi     = 0.5;                             % pre-stim interval; seconds
vowel.postisi    = 1;                               % post-stim interval; seconds

%% Greetings

fid = 1;
fprintf(fid, 'VOWEL PARAMETERS \n');
fprintf(fid, 'F0 = %1.0f\n', vowel.F0);
fprintf(fid, 'Frequencies = %d\n', vowel.freqs);
fprintf(fid, 'Timbre = [%s]\n', vowel.timbre);
fprintf(fid, 'Formant frequencies = %d\n', vowel.formants);
fprintf(fid, 'Level = %d\n', vowel.level);
fprintf(fid, '\n');
fprintf(fid, 'EXPERIMENT PARAMETERS  \n');
fprintf(fid, 'Training phase:       Days 1-4: May 30 - June 2 \n');
fprintf(fid, 'Testing phase:        Days 5,8,10,12,15: June 3, 6, 8, 10, 13 \n');
fprintf(fid, '\n');
fprintf(fid, 'ENTER EXPERIMENT DETAILS \n');


%% Specify experimental condition, animal group and testing day

grid.day_expt    = input('Enter the day of experiment - 1/2/3/4/5 etc.: ');
grid.ferret      = input('Enter the name of the ferret: ','s');

if(grid.day_expt < 5)
    warning('Training days = 1/2/3/4 only');
    grid.condition   = 'Training';  
    fprintf(1, '%%%%%   grid.condition = [%s]\n', grid.condition);
else
    warning('Test days = 5/8/10/12/15 only');
    grid.condition = 'Test';
    fprintf(1, '%%%%%   grid.condition = [%s]\n', grid.condition);
end


% Training phase
if(strcmpi(grid.condition,'Training'))
        
    vowel.dur                       = [0.15 0.20 0.15 0.20];           % seconds
    fprintf(fid, 'Duration = %d\n', vowel.dur);
    grid.stimGrid                   = vowel.freqs;
    grid.repeatsPerCondition        = 48; % 48 repeats of 1 fixed stimulus
    
end

% Test phase
if(strcmpi(grid.condition,'Test'))
        
    vowel.sequence                  = input('Enter name of sequence - [ABCDfamiliar / ABCDnovel / DCBAfamiliar / DCBAnovel]: ','s');
    
    if(strcmpi(vowel.sequence,'ABCDfamiliar'))
        vowel.dur                   = [0.15 0.20 0.15 0.20];           % seconds
        fprintf(fid, 'Duration = %d\n', vowel.dur);
        grid.stimGrid               = vowel.freqs;
    end  
    
    if(strcmpi(vowel.sequence,'ABCDnovel'))
        vowel.dur                   = [0.20 0.15 0.20 0.15];           % seconds
        fprintf(fid, 'Duration = %d\n', vowel.dur);
        grid.stimGrid               = vowel.freqs;
    end  
    
    if(strcmpi(vowel.sequence,'DCBAfamiliar'))
        vowel.dur                   = [0.15 0.20 0.15 0.20];           % seconds
        fprintf(fid, 'Duration = %d\n', vowel.dur);
        grid.stimGrid               = vowel.freqs(end:-1:1);
    end
    
    if(strcmpi(vowel.sequence,'DCBAnovel'))
        vowel.dur                   = [0.20 0.15 0.20 0.15];           % seconds
        grid.stimGrid               = vowel.freqs;
    end  
    
    grid.repeatsPerCondition        = 48; % 48 repeats of each of 1 fixed test stimuli per block
end


%% sweep parameters

grid.postStimSilence    = 0; % in seconds (added in stimgen_st_vowelsequence_1A)
grid.vowel              = vowel;
grid.randomiseGrid      = false;
