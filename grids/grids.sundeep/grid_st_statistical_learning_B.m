function grid = grid_st_statistical_learning_B()

%{

Function: Runs basic Koelsch et al experiment 1 in a single session
Usage:    grid = grid_st_statistical_learning_B()
Home:     grids.sundeep (benware)

Procedure:
- 4 training blocks followed by 2 test blocks
- Each blocks consists of 48 trials each

- Training:     30 repeats of vowel sequence (ABCD; containing 6 x 4-element words) in one block.
                12 repeats of vowel sequence (ABC'D'; containing 6 x 4-element words) in one block.
                 6 repeats of vowel sequence (ABC"D"; containing 6 x 4-element words) in one block.
                 Repeat block x 4
                 Use two different exposure streams across animals

- Test stimuli: Words:      ABCD vs. ABC'D' vs. ABC"D"
                Part-words: CDEF vs. C'D'EF vs. C"D"EF
                
                            (24 repeats per individual w/pw/nw)

------------
Sundeep Teki
v1: 26-Jun-2016 22:51:02

%}

%% required parameters

grid.seed                       = rng;
grid.sampleRate                 = tdt100k;
grid.stimGenerationFunctionName = 'stimgen_st_statistical_learning';
grid.date                       = datestr(now);

%% Stimulus parameters

% stimulus parameters
vowel.F0         = 225; % 175 and 225Hz
vowel.length     = 24;
vowel.num_words  = 6;
vowel.len_words  = 4;
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

vowel.octavesep  = 0.15;
vowel.freqs      = floor(vowel.F0*2.^(vowel.octavesep.*(0:vowel.length-1)));
% vowel.freqs      = vowel.freqs(randperm(length(vowel.freqs)));

vowel.freqs1      = [923
         326
         175
         215
         362
         494
        1261
         446
         294
         402
         750
         239
        1912
        1024
         609
        1553
        1137
        1723
         194
        1400
         549
         832
         676
         265];

vowel.freqs2 = [1800
         636
        2458
         573
         249
        1317
         277
         341
        2216
        1187
        1622
         783
         706
         516
         378
        1070
        1997
         964
         225
         419
         869
        1462
         307
         465];

% choose vowel sequence
vowel.freqs_id      = input('Choose sequence 1 or 2: ');

if(vowel.freqs_id == 1)
    vowel.freqs   = vowel.freqs1;
    vowel.freqs.A = vowel.freqs;
    
    vowel.B1      = floor(vowel.F0*2.^-0.15);
    vowel.B2      = floor(max(vowel.freqs1)*2.^(0.15*2));
    vowel.freqs.B = [vowel.freqs.A(1:12); vowel.B1; vowel.freqs.A(14:18); vowel.B2; vowel.freqs.A(20:24)]; % 13th and 19th element
    
    vowel.C1      = floor(max(vowel.freqs1)*2.^0.15);
    vowel.C2      = floor(vowel.F0*2.^-(0.15*2));    
    vowel.freqs.C = [vowel.freqs.A(1:12); vowel.C1; vowel.freqs.A(14:18); vowel.C2; vowel.freqs.A(20:24)]; % 13th and 19th element
    
    vowel.words.A      = reshape(vowel.freqs.A,vowel.num_words,vowel.len_words);
    vowel.words.B      = reshape(vowel.freqs.B,vowel.num_words,vowel.len_words);
    vowel.words.C      = reshape(vowel.freqs.C,vowel.num_words,vowel.len_words);
    
    vowel.partwords.A  = [vowel.words.A(1,3:4) vowel.words.A(2,1:2)];
    vowel.partwords.B  = [vowel.words.B(1,3:4) vowel.words.B(2,1:2)];
    vowel.partwords.C  = [vowel.words.C(1,3:4) vowel.words.C(2,1:2)];

    
else
    vowel.freqs = vowel.freq2;
    vowel.freqs.A = vowel.freqs;
    
    vowel.B1      = floor(vowel.F0*2.^-0.15);
    vowel.B2      = floor(max(vowel.freqs2)*2.^(0.15*2));
    vowel.freqs.B = [vowel.freqs.A(1:12); vowel.B1; vowel.freqs.A(14:18); vowel.B2; vowel.freqs.A(20:24)]; % 13th and 19th element
    
    vowel.C1      = floor(max(vowel.freqs2)*2.^0.15);
    vowel.C2      = floor(vowel.F0*2.^-(0.15*2));    
    vowel.freqs.C = [vowel.freqs.A(1:12); vowel.C1; vowel.freqs.A(14:18); vowel.C2; vowel.freqs.A(20:24)]; % 13th and 19th element
    
    vowel.words.A      = reshape(vowel.freqs.A,vowel.num_words,vowel.len_words);
    vowel.words.B      = reshape(vowel.freqs.B,vowel.num_words,vowel.len_words);
    vowel.words.C      = reshape(vowel.freqs.C,vowel.num_words,vowel.len_words);
    
    vowel.partwords.A  = [vowel.words.A(1,3:4) vowel.words.A(2,1:2)]; % only first pw
    vowel.partwords.B  = [vowel.words.B(1,3:4) vowel.words.B(2,1:2)]; % only first pw
    vowel.partwords.C  = [vowel.words.C(1,3:4) vowel.words.C(2,1:2)]; % only first pw
end


%% vowel parameters
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
    grid.stimGrid               = vowel.freqs;
    grid.stimGridTitles         = {'F1','F2','F3','F4','F5','F6','F7','F8','F9','10','F11','F12','F13','F14','F15','F16','F17','F18','F19','F20','F21','F22','F23','F24'};
    grid.repeatsPerCondition    = 48; % 48 repeats of 1 fixed stimulus
    vowel.preisi                = 0;                               % pre-stim interval; seconds
    vowel.postisi               = 0;                               % post-stim interval; seconds    
    
    vowel.train_stim            = [1 2 3]; % 1 for words, 2 for part-words
    vowel.repeats               = [30 12 6]; % Ratio: 0.625: 0.25: 0.125
    vowel.sequence_id           = [repmat(vowel.train_stim(1),1,vowel.repeats(1)) repmat(vowel.train_stim(2),1,vowel.repeats(2)) repmat(vowel.train_stim(3),1,vowel.repeats(3))];
    vowel.rand_sequence_id      = vowel.sequence_id(randperm(length(vowel.sequence_id)));
    
    for i = 1:length(vowel.rand_sequence_id)
        
        % stream A
        if(vowel.rand_sequence_id(i)==1)
            grid.stimGrid               = vowel.words.A;
            grid.repeatsPerCondition    = 1;
            
            % stream B
        elseif(vowel.rand_sequence_id(i)==2)
            grid.stimGrid               = vowel.words.B;
            grid.repeatsPerCondition    = 1;
            
            % stream C
        elseif(vowel.rand_sequence_id(i)==3)
            grid.stimGrid               = vowel.words.C;
            grid.repeatsPerCondition    = 1;
        end
        
    end
    
end


% Test phase
if(strcmpi(grid.condition,'Test'))
    
    grid.stimGridTitles             = {'F1','F2','F3','F4'};
    vowel.test_stim                 = [11 12 13 21 22 23]; % 1 for words, 2 for part-words
    vowel.repeats                   = 24;
    vowel.sequence_id               = repmat(vowel.test_stim,1,vowel.repeats);
    vowel.rand_sequence_id          = vowel.sequence_id(randperm(length(vowel.sequence_id)));
    vowel.preisi                    = 0.3;                               % pre-stim interval; seconds
    vowel.postisi                   = 0.3;                               % post-stim interval; seconds
    
    for i = 1:length(vowel.rand_sequence_id)
        
        % words
        if(vowel.rand_sequence_id(i)==11)
            grid.stimGrid               = vowel.words.A(1,:); % only first word
            grid.repeatsPerCondition    = 1;
            
        elseif(vowel.rand_sequence_id(i)==12)
            grid.stimGrid               = vowel.words.B(1,:); % only first word
            grid.repeatsPerCondition    = 1;
            
        elseif(vowel.rand_sequence_id(i)==13)
            grid.stimGrid               = vowel.words.C(1,:); % only first word
            grid.repeatsPerCondition    = 1;
            
            % part-words
        elseif(vowel.rand_sequence_id(i)==21)
            grid.stimGrid               = vowel.partwords.A;
            grid.repeatsPerCondition    = 1;
            
        elseif(vowel.rand_sequence_id(i)==22)
            grid.stimGrid               = vowel.partwords.B;
            grid.repeatsPerCondition    = 1;
            
        elseif(vowel.rand_sequence_id(i)==23)
            grid.stimGrid               = vowel.partwords.C;
            grid.repeatsPerCondition    = 1;
        end
        
    end
    
end


%% sweep parameters

grid.postStimSilence    = 0; % in seconds (added in stimgen_st_vowelsequence_1A)
grid.vowel              = vowel;
grid.randomiseGrid      = false;
