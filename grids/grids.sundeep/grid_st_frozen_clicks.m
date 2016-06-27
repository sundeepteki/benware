function grid = grid_st_frozen_clicks()

%{

Function: Runs basic Pressnitzer noise memory experiment 
Usage:    grid = grid_st_frozen_clicks()
Home:     grids.sundeep (benware)

Procedure: 
- 4 training blocks followed by 2 test blocks
- C: 0.5s click, Ref/RC: 2 x 0.25s repeat
- Training stimuli: 96 trials per block: 24 RefRC, 24 RC, 48 C. Different RefRC per block
- Test stimuli:     2 x blocks: 4 RefRC x 24 trials, 96 fresh RC trials, 192 C trials (384 trials)

------------    
Sundeep Teki
v1: 27-Jun-2016 00:34:22

To do:
Fix test phase - 4 Refs, RC, C

%}

%% required parameters

grid.seed                       = rng;
grid.sampleRate                 = tdt100k;
grid.stimGenerationFunctionName = 'stimgen_st_frozen_clicks'; 
grid.date                       = datestr(now);

%% Stimulus parameters

click.mingap        = 0.01;    % minimum gap duration in seconds
click.maxgap        = 0.050;  % maximum gap duration in seconds
click.replength     = 0.25; % duration of a single repeat
click.nreps         = 2; % number of repeats
click.RCpercent     = 25; 
click.RefRCpercent  = 25;
click.stimtype      = 2; % stimulus type: 0 is N, 1 is RN, 2 is RefRN
click.testtype      = 1;
click.seed          = [];
click.reseed        = [];
click.highpass      = 2000; % high-pass filter cutoff
click.clickdur      = 0.00005;
click.fs            = tdt100k; % sampling rate
click.clicksamples  = [];
click.clicktimes    = [];
click.level         = 65;                              % dB
click.amp           = 20e-6*10.^(click.level/20);      % convert to Pascals
click.hannramp      = 0.005;                           % ramp size - 5ms
click.preisi        = 0.25;                             % pre-stim interval; seconds
click.postisi       = 0.25;                               % post-stim interval; seconds
click.num_trials    = 96;

%% Greetings

fid = 1;
fprintf(fid, 'CLICK PARAMETERS \n');
fprintf(fid, 'Minimum gap = %d\n', click.mingap);
fprintf(fid, 'Maximum gap = %d\n', click.maxgap);
fprintf(fid, 'Repeat length = %d\n', click.replength);
fprintf(fid, 'No. of repeats = %d\n', click.nreps);
fprintf(fid, 'Level = %d\n', click.level);
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
                    
    grid.repeatclickerCondition = 1; 
    click.sequence_id           = tshuffle([ones(1,floor(click.RCpercent*click.num_trials/100)) 2*ones(1,floor(click.RefRCpercent*click.num_trials/100)) zeros(1,floor((click.num_trials- (click.RCpercent + click.RefRCpercent)*click.num_trials)))], [2]);    
    grid.stimGridTitles         = click.sequence_id;
        
    for i = 1:length(click.sequence_id)
        
        click.stimtype = click.sequence_id(i);
        
        % RefRC
        if(click.stimtype==2)
            grid.stimGrid               = 2;
            grid.repeatsperCondition    = 1;
            
            % stream B
        elseif(click.stimtype==1)
            grid.stimGrid               = 1;
            grid.repeatsperCondition    = 1;
            
            % stream C
        elseif(click.stimtype==0)
            grid.stimGrid               = 0;
            grid.repeatsperCondition    = 1;
        end
        
    end
    
end


% Test phase
if(strcmpi(grid.condition,'Test'))
    
                         % post-stim interval; seconds
    
    for i = 1:length(click.rand_sequence_id)
        
        % words
        if(click.rand_sequence_id(i)==11)
            grid.stimGrid               = click.words.A(1,:); % only first word
            grid.repeatclickerCondition    = 1;
            
        elseif(click.rand_sequence_id(i)==12)
            grid.stimGrid               = click.words.B(1,:); % only first word
            grid.repeatclickerCondition    = 1;
            
        elseif(click.rand_sequence_id(i)==13)
            grid.stimGrid               = click.words.C(1,:); % only first word
            grid.repeatclickerCondition    = 1;
            
            % part-words
        elseif(click.rand_sequence_id(i)==21)
            grid.stimGrid               = click.partwords.A;
            grid.repeatclickerCondition    = 1;
            
        elseif(click.rand_sequence_id(i)==22)
            grid.stimGrid               = click.partwords.B;
            grid.repeatclickerCondition    = 1;
            
        elseif(click.rand_sequence_id(i)==23)
            grid.stimGrid               = click.partwords.C;
            grid.repeatclickerCondition    = 1;
        end
        
    end
    
end


%% sweep parameters

grid.postStimSilence    = 0; % in seconds (added in stimgen_st_clicksequence_1A)
grid.click              = click;
grid.randomiseGrid      = false;
