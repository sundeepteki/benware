function grid = grid_st_vowelsequence_1A_v2()

%{

Function to run basic Gavornik and Bear experiment 1A but in a single session rather than multiple days.

The experiment consists of:
- 4 training sessions and 1 test session conducted on the same day.
- Each session consists of 4 blocks of 50 trials each.
- Run in Munchkin (Control), Paprika and Lavender (Experimental).
- Different stimuli from experiment 1A.
    
Sundeep Teki
v1: 31.05.16

%}

%% required parameters

grid.seed                       = rng;
grid.sampleRate                 = tdt100k;
grid.stimGenerationFunctionName = 'stimgen_st_vowelsequence_1A'; % identical stimgen to experiment 1A
grid.date                       = datestr(now);

%% Stimulus parameters

grid.stimGridTitles = {'Frequency of vowel 1','Frequency of vowel 2','Frequency of vowel 3','Frequency of vowel 4'};

% stimulus parameters
vowel.F0         = 150; % Hz
vowel.order      = [3 1 0 2];
vowel.timbre     = 'e';

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
vowel.freqs      = floor(vowel.F0*2.^(vowel.octavesep.*vowel.order)); % [713 252 150 424]; for experiment 1A_v2
vowel.bandwidth  = [80 70 160 300];                 % Hz, constant for each vowel
vowel.dur        = 0.15;                            % seconds
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
fprintf(fid, 'Duration = %d\n', vowel.dur);
fprintf(fid, 'Level = %d\n', vowel.level);
fprintf(fid, '\n');
fprintf(fid, 'EXPERIMENT PARAMETERS  \n');
fprintf(fid, 'Experimental animals: Lavender and Paprika \n');
fprintf(fid, 'Control animals:      Munchkin\n');
fprintf(fid, 'Training phase:       Sessions 1-4 \n');
fprintf(fid, 'Testing phase:        Session  5 \n');
fprintf(fid, '\n');
fprintf(fid, 'ENTER EXPERIMENT DETAILS \n');


%% Specify experimental condition, animal group and testing day

grid.session_expt    = input('Enter the experimental session number - 1/2/3/4/5 : ');
grid.ferret          = input('Enter the name of the ferret: ','s');
grid.animalgroup     = input('Enter the animal group - [Experimental / Control]: ','s');

if(grid.session_expt < 5)
    warning('Training sessions = 1/2/3/4 only');
    grid.condition   = 'Training';  
    fprintf(1, '%%%%%   grid.condition = [%s]\n', grid.condition);
else
    warning('Test session = 5 only');
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
    
    vowel.sequence                  = input('Enter name of sequence - [ABCD / DCBA / ABCD300]: ','s');
    
    if(strcmpi(vowel.sequence,'ABCD'))
        grid.stimGrid               = vowel.freqs;
    end
    
    if(strcmpi(vowel.sequence,'ABCD300'))
        vowel.dur                   = 0.3;
        grid.stimGrid               = vowel.freqs;
    end
    
    if(strcmpi(vowel.sequence,'DCBA'))
        grid.stimGrid               = vowel.freqs(end:-1:1);
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
    
    vowel.sequence                  = input('Enter name of sequence - [ABCD / DCBA / ABCD300]: ','s');
    
    if(strcmpi(vowel.sequence,'ABCD'))
        grid.stimGrid               = vowel.freqs;
    end
    
    if(strcmpi(vowel.sequence,'ABCD300'))
        vowel.dur                   = 0.3;
        grid.stimGrid               = vowel.freqs;
    end
    
    if(strcmpi(vowel.sequence,'DCBA'))
        grid.stimGrid               = vowel.freqs(end:-1:1);
    end
    
    grid.repeatsPerCondition        = 48; % 48 repeats of each of the 3 test stimuli
end

%% sweep parameters

grid.postStimSilence    = 0; % in seconds (added in stimgen_st_vowelsequence_1A)
grid.vowel              = vowel;
grid.randomiseGrid      = false;
