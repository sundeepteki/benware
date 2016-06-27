function grid = grid_st_sequencelearning_A()

%{

Function: Runs basic Gavornik and Bear experiment 1A in a single session 
Usage:    grid = grid_st_sequencelearning_A()
Home:     grids.sundeep (benware)

Procedure: 
- 4 training blocks followed by 2 test blocks
- Each blocks consists of 48 trials each

- Experimental condition: present ABCD during training
- Control condition: present 24 combinatiosn of A,B,C,D during training
- Test stimuli: ABCD, DCBA, ABCD300, ABCD(tone). 48 repeats of each stimuli in randomised order

------------    
Sundeep Teki
v1: 24-Jun-2016 22:21:31

%}

%% required parameters

grid.seed                       = rng;
grid.sampleRate                 = tdt100k;
grid.stimGenerationFunctionName = 'stimgen_st_sequencelearning_vowel'; 
grid.date                       = datestr(now);

%% Stimulus parameters

grid.stimGridTitles = {'Frequency [1]','Frequency [2]','Frequency [3]','Frequency [4]'};

% stimulus parameters
vowel.F0         = 192; % Hz
vowel.order      = [1 3 0 2];
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
vowel.dur        = 0.15;                            % seconds
vowel.level      = 65;                              % dB
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
fprintf(fid, 'Experimental animal : Paprika \n');
fprintf(fid, 'Control animal:       Lavender\n');
fprintf(fid, 'Training phase:       Blocks 1-4 \n');
fprintf(fid, 'Testing phase:        Blocks 5-6 \n');
fprintf(fid, '\n');
fprintf(fid, 'ENTER EXPERIMENT DETAILS \n');


%% Specify experimental condition, animal group and testing day

grid.session_expt    = input('Enter the block number - 1:6 : ');
grid.ferret          = input('Enter the name of the ferret: ','s');
grid.animalgroup     = input('Enter the animal group - [Experimental / Control]: ','s');

if(grid.session_expt < 5)
    warning('Training blocks = 1:4 only');
    grid.condition   = 'Training';  
    fprintf(1, '%%%%%   grid.condition = [%s]\n', grid.condition);
else
    warning('Test block = 5:6 only');
    grid.condition = 'Test';
    fprintf(1, '%%%%%   grid.condition = [%s]\n', grid.condition);
end


% Experimental group of animals - training phase
if(strcmpi(grid.animalgroup,'Experimental') && strcmpi(grid.condition,'Training'))
        
    grid.stimGrid                   = vowel.freqs;
    grid.repeatsPerCondition        = 48; % 48 repeats of 1 fixed stimulus
    
end

% Experimental group of animals - test phase
if(strcmpi(grid.animalgroup,'Experimental') && strcmpi(grid.condition,'Test'))
    
    vowel.sequence                  = input('Enter name of sequence - [ABCD / DCBA / ABCD300 / ABCDnew]: ','s');
    
    if(strcmpi(vowel.sequence,'ABCD'))
        grid.stimGrid               = vowel.freqs;    
    
    elseif(strcmpi(vowel.sequence,'ABCD300'))
        vowel.dur                   = 0.3;
        grid.stimGrid               = vowel.freqs;
        
    elseif(strcmpi(vowel.sequence,'DCBA'))
        grid.stimGrid               = vowel.freqs(end:-1:1);    
    
    elseif(strcmpi(vowel.sequence,'ABCDnew'))
        vowel.timbre     = 'e';
        vowel.formants   = [730 2058 2979 4294];            % for vowel e        
        grid.stimGrid    = vowel.freqs;
    else
        fprintf(fid, 'Enter one of the 4 valid sequences only  \n');        
    end
    
    grid.repeatsPerCondition        = 48; % 48 repeats of each of 1 fixed test stimuli per block
end

% Control group of animals - training phase
if(strcmpi(grid.animalgroup,'Control') && strcmpi(grid.condition,'Training'))
    
    temp                            = vowel.freqs(perms(1:length(vowel.freqs))); % 24 permutations
    temp1                           = repmat(temp,2,1); % 48 trials
    grid.stimGrid                   = temp1(randperm(length(temp1)),:);
    grid.repeatsPerCondition        = 1; % 1 repeat per unique scrambled stimulus
    
end

% Control group of animals - test phase
if(strcmpi(grid.animalgroup,'Control') && strcmpi(grid.condition,'Test'))
    
    vowel.sequence                  = input('Enter name of sequence - [ABCD / DCBA / ABCD300 / ABCDnew]: ','s');
    
    if(strcmpi(vowel.sequence,'ABCD'))
        grid.stimGrid               = vowel.freqs;    
    
    elseif(strcmpi(vowel.sequence,'ABCD300'))
        vowel.dur                   = 0.3;
        grid.stimGrid               = vowel.freqs;    
    
    elseif(strcmpi(vowel.sequence,'DCBA'))
        grid.stimGrid               = vowel.freqs(end:-1:1);
    
    elseif(strcmpi(vowel.sequence,'ABCDnew'))
        vowel.timbre     = 'e';
        vowel.formants   = [730 2058 2979 4294];            % for vowel e
        grid.stimGrid    = vowel.freqs;
    else
        fprintf(fid, 'Enter one of the 4 valid sequences only  \n');        
    end
    
    grid.repeatsPerCondition        = 48; % 48 repeats of each of the 3 test stimuli
end


%% sweep parameters

grid.postStimSilence    = 0; % in seconds (added in stimgen_st_vowelsequence_1A)
grid.vowel              = vowel;
grid.randomiseGrid      = false;
