function stim = stimgen_st_SFG(expt, grid, varargin)

%{

Function to make SFG stimuli

------------
Sundeep Teki
v1: 12-Jul-2016 11:31:22

%}

%% get parameters

sampleRate  = grid.sampleRate;
nChannels   = expt.nStimChannels;
sfg         = grid.sfg;
% vowel_freqs = cell2mat(varargin);

%% make sfg vector

for i = 1:length(sfg.cond_trials)
    
    if(sfg.cond_trials(i) == 0)
        
        t = 0:1/(sampleRate-1):sfg.dur;
        waveform =[];
        
        for k=1:length(sfg.num_bursts)
            
            ran         = randperm(length(sfg.freqs));
            coh_comp    = sfg.freqs(ran(1:n_coh));                     % these are the coherent components
            comp_rest   = sfg.freqs(ran(n_coh+1:end));
            n_c         = n_c_min + round(rand*(n_c_max-n_c_min));  % random between n_c_min and n_c_max
            t1          = randperm(length(comp_rest));
            noncoh_comp = comp_rest(t1(1:n_c));
            all_comp    = [coh_comp noncoh_comp];
            sig2        = [];
            
            for m=1:length(all_comp)
                sig2 = [sig2;(0.2/n_c_max)*sin(2*pi*all_comp(m)*t)];
            end
            
            temp     = sum(sig2);
            sig      = [sig temp];
            waveform = [waveform sig];
            
        end
        
        waveform = sfg.amp/sqrt(mean(waveform.^2)) .* waveform; % set the amplitude using the rms of the waveform
        window   = hanning(ceil(sampleRate*2*sfg.hannramp),'periodic');   % ST edit
        window   = [window(1:ceil(sampleRate*sfg.hannramp)) ; ones(nsamples-ceil(sampleRate*sfg.hannramp)-floor(sampleRate*sfg.hannramp)-1,1) ; window(floor(sampleRate*sfg.hannramp)+1:end)]; % build hanning window for stimulus
        waveform = waveform.* window';                   % apply window
        
    % create figure stimuli
    elseif(sfg.cond_trials(i) == 1)
        
        t         = 0:1/(sampleRate-1):sfg.dur;
        ran       = randperm(length(sfg.freqs));   
        coh_comp  = sfg.freqs(ran(1:n_coh));       
        comp_rest = sfg.freqs(ran(n_coh+1:end));   
        waveform  = [];
        
        for k=1:length(sfg.num_bursts)
            
            n_c         = n_c_min+round(rand*(n_c_max-n_c_min));     % no. of components in a chord
            t1          = randperm(length(comp_rest));                 % randomise list of
            noncoh_comp = comp_rest(t1(1:n_c));
            all_comp    = [coh_comp noncoh_comp];
            sig2        = [];
            
            for m=1:length(all_comp)
                sig2=[sig2;(0.2/n_c_max)*sin(2*pi*all_comp(m)*t)]; % normalized here
            end
            
            temp=sum(sig2);
            sig=[sig temp];
            waveform = [waveform sig];
            
        end
        
        waveform = sfg.amp/sqrt(mean(waveform.^2)) .* waveform; % set the amplitude using the rms of the waveform
        window   = hanning(ceil(sampleRate*2*sfg.hannramp),'periodic');   % ST edit
        window   = [window(1:ceil(sampleRate*sfg.hannramp)) ; ones(nsamples-ceil(sampleRate*sfg.hannramp)-floor(sampleRate*sfg.hannramp)-1,1) ; window(floor(sampleRate*sfg.hannramp)+1:end)]; % build hanning window for stimulus
        waveform = waveform.* window';                   % apply window
        
    end
    
end

%% make sfg sequence with pre- and post-stim silence

pre_silence  = zeros(1,round(sfg.prestim*sampleRate));
post_silence = zeros(1,round(sfg.poststim*sampleRate));
stim         = [pre_silence seq_sfg post_silence];

%% write sound file if required
% audiowrite(['/Users/sundeepteki/Documents/Oxford/Work/Code/tekilib/#teki/stimuli/sundeep/st_sequencelearning_B_Test_x_2/st_sequencelearning_B_DCBAfamiliar.wav'],stim',97656);

