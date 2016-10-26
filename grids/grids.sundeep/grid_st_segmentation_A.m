function grid = grid_st_segmentation_A()

%{

Function: Runs basic Pena et al experiment 1 in a single session
Usage:    grid = grid_st_segmentation_A()
Home:     grids.sundeep (benware)

Procedure:
- 4 training blocks followed by 2 test blocks
- Each blocks consists of 48 trials each

- Training:     AXC = A(BC)D. 9 AXC words with same X, 3As and 3Cs. Element duration: 150ms
                192 repeats (same amount of exposure as experiments 1 & 2). 48 repeats x 4 blocks               
                Use two different exposure streams across animals

- Test stimuli: Words (ABCD) vs. Non-words vs. rule-words (A'BCD') x 48 repeats per category (8 repeats per individual w/pw/nw)

------------
Sundeep Teki
v1: 27-Jun-2016 21:57:09

%}

%% required parameters

grid.seed                       = rng;
grid.sampleRate                 = tdt100k;
grid.stimGenerationFunctionName = 'stimgen_st_segmentation';
grid.date                       = datestr(now);

%% Stimulus parameters

% stimulus parameters
vowel.timbre    = 'a';

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

vowel.octavesep  = 0.15;
vowel.A         = [180 278 345]; % 200Hz and 150Hz
vowel.X1        = 315;
vowel.X2        = 426;
vowel.C         = [515 128 216]; 

vowel.words     = [[vowel.A(1) vowel.X1 vowel.X2 vowel.C(1)];...
                   [vowel.A(1) vowel.X1 vowel.X2 vowel.C(2)];...
                   [vowel.A(1) vowel.X1 vowel.X2 vowel.C(3)];...
                   [vowel.A(2) vowel.X1 vowel.X2 vowel.C(1)];...
                   [vowel.A(2) vowel.X1 vowel.X2 vowel.C(2)];...
                   [vowel.A(3) vowel.X1 vowel.X2 vowel.C(3)];...
                   [vowel.A(3) vowel.X1 vowel.X2 vowel.C(1)];...
                   [vowel.A(3) vowel.X1 vowel.X2 vowel.C(2)];...
                   [vowel.A(3) vowel.X1 vowel.X2 vowel.C(3)]];

                   [ones(1,100) 2*ones(1,100) 3*ones(1,100) 4*ones(1,100) 5*ones(1,100) 6*ones(1,100) 7*ones(1,100) 8*ones(1,100) 9*ones(1,100)];
                   
                   
vowel.partwords  = [];

vowel.rulewords  = [];

% vowel parameters
vowel.bandwidth  = [80 70 160 300];                 % Hz, constant for each vowel
vowel.dur        = 0.15;                            % seconds
vowel.level      = 65;                              % dB
vowel.amp        = 20e-6*10.^(vowel.level/20);      % convert to Pascals
vowel.carrier    = 'clicktrain';
vowel.hannramp   = 0.005;                           % ramp size - 5ms
vowel.preisi     = 0;                               % pre-stim interval; seconds
vowel.postisi    = 0;                               % post-stim interval; seconds

%% Greetings

fid = 1;
fprintf(fid, 'VOWEL PARAMETERS \n');
fprintf(fid, 'F0 = %1.0f\n', vowel.F0);
fprintf(fid, 'Timbre = [%s]\n', vowel.timbre);
fprintf(fid, 'Formant frequencies = %d\n', vowel.formants);
fprintf(fid, 'Duration = %d\n', vowel.dur);
fprintf(fid, 'Level = %d\n', vowel.level);
fprintf(fid, '\n');
fprintf(fid, 'EXPERIMENT PARAMETERS  \n');
fprintf(fid, 'Training phase:       Block 1 \n');
fprintf(fid, 'Testing phase:        Block 2:3 \n');
fprintf(fid, '\n');
fprintf(fid, 'ENTER EXPERIMENT DETAILS \n');


%% Specify experimental condition, animal group and testing day

grid.session_expt    = input('Enter the block number - 1:3 : ');
grid.ferret          = input('Enter the name of the ferret: ','s');

if(grid.session_expt < 2)
    warning('Training blocks = 1 only');
    grid.condition   = 'Training';
    fprintf(1, '%%%%%   grid.condition = [%s]\n', grid.condition);
else
    warning('Test block = 2:3 only');
    grid.condition = 'Test';
    fprintf(1, '%%%%%   grid.condition = [%s]\n', grid.condition);
end


% Training phase
if(strcmpi(grid.condition,'Training'))
    
    grid.stimGrid                   = vowel.freqs;
    grid.stimGridTitles             =  {'F1','F2','F3','F4','F5','F6','F7','F8','F9','10','F11','F12','F13','F14','F15','F16','F17','F18','F19','F20','F21','F22','F23','F24'};
    grid.repeatsPerCondition        = 48; % 48 repeats of 1 fixed stimulus
    vowel.preisi                    = 0;                               % pre-stim interval; seconds
    vowel.postisi                   = 0;                               % post-stim interval; seconds
end

% Test phase
if(strcmpi(grid.condition,'Test'))
    
    grid.stimGridTitles = {'F1','F2','F3','F4'};
    vowel.test_stim                 = [11 12 13 14 15 16 21 22 23 24 25 26 31 32 33 34 35 36]; % 1 for words, 2 for part-words, 3 for non-words
    vowel.repeats                   = 8;
    vowel.sequence_id               = repmat(vowel.test_stim,1,vowel.repeats);
    vowel.rand_sequence_id          = vowel.sequence_id(randperm(length(vowel.sequence_id)));
    vowel.preisi                    = 0.3;                               % pre-stim interval; seconds
    vowel.postisi                   = 0.3;                               % post-stim interval; seconds
    
    for i = 1:length(vowel.rand_sequence_id)
        
        % words
        if(vowel.rand_sequence_id(i)==11)
            grid.stimGrid               = vowel.words(1,:);
            grid.repeatsPerCondition    = 1;
            
        elseif(vowel.rand_sequence_id(i)==12)
            grid.stimGrid               = vowel.words(2,:);
            grid.repeatsPerCondition    = 1;
            
        elseif(vowel.rand_sequence_id(i)==13)
            grid.stimGrid               = vowel.words(3,:);
            grid.repeatsPerCondition    = 1;
            
        elseif(vowel.rand_sequence_id(i)==14)
            grid.stimGrid               = vowel.words(4,:);
            grid.repeatsPerCondition    = 1;
            
        elseif(vowel.rand_sequence_id(i)==15)
            grid.stimGrid               = vowel.words(5,:);
            grid.repeatsPerCondition    = 1;
            
        elseif(vowel.rand_sequence_id(i)==16)
            grid.stimGrid               = vowel.words(6,:);
            grid.repeatsPerCondition    = 1;
            
            % part-words
        elseif(vowel.rand_sequence_id(i)==21)
            grid.stimGrid               = vowel.partwords(1,:);
            grid.repeatsPerCondition    = 1;
            
        elseif(vowel.rand_sequence_id(i)==22)
            grid.stimGrid               = vowel.partwords(2,:);
            grid.repeatsPerCondition    = 1;
            
        elseif(vowel.rand_sequence_id(i)==23)
            grid.stimGrid               = vowel.partwords(3,:);
            grid.repeatsPerCondition    = 1;
            
        elseif(vowel.rand_sequence_id(i)==24)
            grid.stimGrid               = vowel.partwords(4,:);
            grid.repeatsPerCondition    = 1;
            
        elseif(vowel.rand_sequence_id(i)==25)
            grid.stimGrid               = vowel.partwords(5,:);
            grid.repeatsPerCondition    = 1;
            
        elseif(vowel.rand_sequence_id(i)==26)
            grid.stimGrid               = vowel.partwords(6,:);
            grid.repeatsPerCondition    = 1;
            
            % non-words
        elseif(vowel.rand_sequence_id(i)==31)
            grid.stimGrid               = vowel.nonwords(1,:);
            grid.repeatsPerCondition    = 1;
            
        elseif(vowel.rand_sequence_id(i)==32)
            grid.stimGrid               = vowel.nonwords(2,:);
            grid.repeatsPerCondition    = 1;
            
        elseif(vowel.rand_sequence_id(i)==33)
            grid.stimGrid               = vowel.nonwords(3,:);
            grid.repeatsPerCondition    = 1;
            
        elseif(vowel.rand_sequence_id(i)==34)
            grid.stimGrid               = vowel.nonwords(4,:);
            grid.repeatsPerCondition    = 1;
            
        elseif(vowel.rand_sequence_id(i)==35)
            grid.stimGrid               = vowel.nonwords(5,:);
            grid.repeatsPerCondition    = 1;
            
        elseif(vowel.rand_sequence_id(i)==36)
            grid.stimGrid               = vowel.nonwords(6,:);
            grid.repeatsPerCondition    = 1;
                    
    end
    
end


%% sweep parameters

grid.postStimSilence    = 0; % in seconds (added in stimgen_st_vowelsequence_1A)
grid.vowel              = vowel;
grid.randomiseGrid      = false;
