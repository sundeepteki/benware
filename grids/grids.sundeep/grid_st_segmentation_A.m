function grid = grid_st_segmentation_A()

%{

Function: Runs basic Pena et al experiment 1 in a single session
Usage:    grid = grid_st_segmentation_A()
Home:     grids.sundeep (benware)

Procedure:
- 4 training blocks followed by 2 test blocks
- Each blocks consists of 48 trials each

- Training:     AXC = A(BC)D. 6 AXC words. Element duration: 150ms
                192 repeats (same amount of exposure as experiments 1 & 2). 48 repeats x 4 blocks               
                Use two different exposure streams across animals

- Test stimuli: Words (ABCD) / Non-words / rule-words (A'BCD') x 48 repeats per category (8 repeats per individual w/pw/nw)

------------
Sundeep Teki
v1: 27-Jun-2016 00:12:18

To do: see stimulus design in paper and code this and stimgen.

%}

%% required parameters

grid.seed                       = rng;
grid.sampleRate                 = tdt100k;
grid.stimGenerationFunctionName = 'stimgen_st_segmentation';
grid.date                       = datestr(now);

%% Stimulus parameters

% stimulus parameters
vowel.F0         = 150; % 200Hz and 150Hz
vowel.length     = 24;
vowel.num_words  = 6;
vowel.len_words  = 4;
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

vowel.octavesep  = 0.15;
vowel.freqs      = floor(vowel.F0*2.^(vowel.octavesep.*(0:vowel.length-1)));
% vowel.freqs      = vowel.freqs(randperm(length(vowel.freqs)));

vowel.freqs1      = [273
    1969
    221
    1055
    857
    303
    565
    951
    459
    1600
    1775
    246
    336
    200
    509
    1171
    414
    772
    1299
    2185
    1442
    373
    627
    696];

vowel.freqs2 = [1331
         974
         310
         279
         579
         184
         344
         150
        1081
         791
        1200
        1639
         643
         252
         227
         470
         522
        1477
         166
         713
         382
         424
         204
         878];

% choose vowel sequence
vowel.freqs_id      = input('Choose sequence 1 or 2: ');
if(vowel.freqs_id == 1)
    vowel.freqs = vowel.freqs1;
else
    vowel.freqs = vowel.freq2;
end

vowel.words      = reshape(vowel.freqs,vowel.num_words,vowel.len_words);

vowel.partwords  = [[vowel.words(1,3:4) vowel.words(2,1:2)]; [vowel.words(2,3:4) vowel.words(3,1:2)];[vowel.words(3,3:4) vowel.words(4,1:2)]; ...
                   [vowel.words(4,3:4) vowel.words(5,1:2)]; [vowel.words(5,3:4) vowel.words(6,1:2)]; [vowel.words(6,3:4) vowel.words(1,1:2)]];

vowel.rand_freqs = vowel.freqs(randperm(length(vowel.freqs))); % randomise again
vowel.nonwords   = reshape(vowel.rand_freqs,vowel.num_words,vowel.len_words);

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
fprintf(fid, 'Frequencies = %d\n', vowel.freqs);
fprintf(fid, 'Word 01 = %d\n', vowel.words(1,:));
fprintf(fid, 'Word 02 = %d\n', vowel.words(2,:));
fprintf(fid, 'Word 03 = %d\n', vowel.words(3,:));
fprintf(fid, 'Word 04 = %d\n', vowel.words(4,:));
fprintf(fid, 'Word 05 = %d\n', vowel.words(5,:));
fprintf(fid, 'Word 06 = %d\n', vowel.words(6,:));
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
    
    grid.stimGrid                   = vowel.freqs;
    grid.stimGridTitles = {'F1','F2','F3','F4','F5','F6','F7','F8','F9','10','F11','F12','F13','F14','F15','F16','F17','F18','F19','F20','F21','F22','F23','F24'};
    grid.repeatsPerCondition        = 48; % 48 repeats of 1 fixed stimulus
    vowel.preisi     = 0;                               % pre-stim interval; seconds
    vowel.postisi    = 0;                               % post-stim interval; seconds
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
