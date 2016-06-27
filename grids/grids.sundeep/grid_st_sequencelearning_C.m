function grid = grid_st_sequencelearning_C()

%{

Function: Runs basic Gavornik and Bear experiment 1C in a single session 
Usage:    grid = grid_st_sequencelearning_C()
Home:     grids.sundeep (benware)

Procedure: 
- 4 training blocks followed by 2 test blocks
- Each blocks consists of 48 trials each

- Training stimuli: ABCD presented to one ear only
- Test stimuli:     ABCD and DCBA presented to each ear monoaurally

------------    
Sundeep Teki
v1: 25-Jun-2016 00:29:32

%}

%% required parameters

grid.seed                       = rng;
grid.sampleRate                 = tdt100k;
grid.stimGenerationFunctionName = 'stimgen_st_sequencelearning_vowel'; 
grid.date                       = datestr(now);

%% Stimulus parameters

grid.stimGridTitles = {'Frequency [1]','Frequency [2]','Frequency [3]','Frequency [4]'};

% stimulus parameters
vowel.F0         = 160; % Hz
vowel.order      = [0 2 1 3];
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
vowel.freqs      = floor(vowel.F0*2.^(vowel.octavesep.*vowel.order)); % [713 252 150 424]
vowel.bandwidth  = [80 70 160 300];                 % Hz, constant for each vowel
vowel.level      = 65;                              % dB
vowel.dur        = 0.15; 
vowel.amp        = 20e-6*10.^(vowel.level/20);      % convert to Pascals
vowel.carrier    = 'clicktrain';
vowel.hannramp   = 0.005;                           % ramp size - 5ms
vowel.preisi     = 0.3;                             % pre-stim interval; seconds
vowel.postisi    = 0.3;                               % post-stim interval; seconds


%% Greetings

fid = 1;
fprintf(fid, 'VOWEL PARAMETERS \n');
fprintf(fid, 'F0 = %1.0f\n', vowel.F0);
fprintf(fid, 'Frequencies = %d\n', vowel.freqs);
fprintf(fid, 'Timbre = [%s]\n', vowel.timbre);
fprintf(fid, 'Formant frequencies = %d\n', vowel.formants);
fprintf(fid, 'Duration = %d\n', vowel.dur);
fprintf(fid, 'Level = %d\n', vowel.level);
fprintf(fid, '\n');
fprintf(fid, 'EXPERIMENT PARAMETERS  \n');
fprintf(fid, 'Training phase:       Blocks 1-4 \n');
fprintf(fid, 'Testing phase:        Blocks 5-6 \n');
fprintf(fid, '\n');
fprintf(fid, 'ENTER EXPERIMENT DETAILS \n');


%% Specify experimental condition, animal group and testing day

grid.session_expt    = input('Enter the block number - 1:6 : ');
grid.ferret          = input('Enter the name of the ferret: ','s');

if(grid.session_expt < 5)
    warning('Training blocks = 1:4 only');
    grid.condition   = 'Training';  
    fprintf(1, '%%%%%   grid.condition = [%s]\n', grid.condition);
else
    warning('Test block = 5:6 only');
    grid.condition = 'Test';
    fprintf(1, '%%%%%   grid.condition = [%s]\n', grid.condition);
end


% Training phase
if(strcmpi(grid.condition,'Training'))
    vowel.ear  = input('Enter ear of presentation - 1 for left / 2 for right : '); 
    grid.stimGrid                   = vowel.freqs;
    fprintf(1, '%%%%%   vowel.ear_train = %s\n', vowel.ear_train);
    grid.repeatsPerCondition        = 48; % 48 repeats of 1 fixed stimulus
    
end

% Test phase
if(strcmpi(grid.condition,'Test'))
        
    vowel.sequence                  = input('Enter name of sequence - [ABCDleft / ABCDright / DCBAleft / DCBAright]: ','s');
    
    if(strcmpi(vowel.sequence,'ABCDleft'))
        vowel.ear       = 1; 
        grid.stimGrid   = vowel.freqs;
    end  
    
    if(strcmpi(vowel.sequence,'ABCDright'))
        vowel.ear       = 2;
        grid.stimGrid   = vowel.freqs;
    end  
    
    if(strcmpi(vowel.sequence,'DCBAleft'))
        vowel.ear       = 1;
        grid.stimGrid   = vowel.freqs(end:-1:1);
    end
    
    if(strcmpi(vowel.sequence,'DCBAright')) 
        vowel.ear       = 2;
        grid.stimGrid   = vowel.freqs;
    end  
    
    grid.repeatsPerCondition        = 48; % 48 repeats of each of 1 fixed test stimuli per block
end


%% sweep parameters

grid.postStimSilence    = 0; % in seconds (added in stimgen_st_vowelsequence_1A)
grid.vowel              = vowel;
grid.randomiseGrid      = false;
