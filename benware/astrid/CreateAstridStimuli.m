function stim = CreateAstridStimuli(settingsfile,compensationfilterfile,seed)
% CreateAstridStimuli() -- generates experiment stimuli as defined by settings
%   Usage:
%      err = CreateAstridStimuli(settingsfile,compensationfilterfile,seed)
%   Parameters:
%      settingsfile                     this file contains the Settings defining the experiment
%      compensationfilterfile           this file contains the two compensation filters (compensationfilter(1,:) is left, compensationfilter(2,:) is right) [optional]
%      seed                             specific random seed to be used [optional]
%   Outputs:
%      stim        struct containing sound stimuli (stim(1).L,stim(1).R,stim(2).L,stim(2).R,...)
%
% Author: stef@nstrahl.de, astrid.klinge-strahl@dpag.ox.ac.uk
% Version: $Id: CreateAstridStimuli.m 146 2014-03-04 21:22:43Z astrid $

dostimplot = false;
stim = [];
t    = clock;                                    % get current time as vector [year month day hour minute seconds]
if ~exist('seed','var')                          % if we didn't get a specific random seed
    seed = round(sum(100*t));                    % generate new random number dependent on current time and make it an integer seed to remember it better
end
rand('twister', seed);                           % use Mersenne Twister pseudo-random number generator

if isempty(settingsfile)                         % if we are called within benware this will be empty and we ask online for the name
    settingsfile_default = sprintf('SettingsMistuned%d_%02.0f_%02.0f.m',t(1),t(2),t(3));
    settingsfile = input(['Please enter the name of the settings file if [' settingsfile_default '] is not correct, else <return>: ']);
    if isempty(settingsfile)                     % did we get just a return then use the offered default
        settingsfile = settingsfile_default;
    end
end
fprintf('Loading settings from %s...\n',settingsfile);

complex = []; % Matlab WTF - otherwise tries to call complex() from toolbox???
freqs = []; % Matlab WTF 2nd

run(settingsfile);                               % load settings

logfilename = sprintf('%d-%02.0f-%02.0f_%02.0f-%02.0f-%02.0f_CreateAstridStimuli_%s.log',t(1),t(2),t(3),t(4),t(5),t(6),settings_parser);
matfilename = sprintf('%d-%02.0f-%02.0f_%02.0f-%02.0f-%02.0f_CreateAstridStimuli_%s.mat',t(1),t(2),t(3),t(4),t(5),t(6),settings_parser);
fid = fopen([logfile_directory logfilename],'a');  % open logfile in assigned directory
fprintf(fid,'%d-%02.0f-%02.0f %02.0f:%02.0f:%02.0f - CreateAstridStimuli started using %s\n',t(1),t(2),t(3),t(4),t(5),t(6),settingsfile);
fprintf(fid,'  random_seed = %1.0f;\n',seed);      % store which random seed was used

switch settings_parser
    case 'CalibrationMistuned'
        fprintf(fid,'  frequency = %1.0f;',frequency);          % store frequency of calibration pure tone (Hz)
        fprintf(fid,'  stim_length = %1.0f;',stim_length);      % store duration of calibration pure tone (sec)
        fprintf(fid,'  level = %1.0f; % (dB SPL)',level);       % store level of calibration pure tone (dB SPL)
        amp = 20e-6*10.^(level/20);                             % convert dB SPL to amplitude (Pascal)
        fprintf(fid,'  amplitude = %f; % (Pascal)\n',amp);      % store amplitude of calibration pure tone

        if exist('compensationfilterfile','var')                % have we been called with a compensation filter
            [norm_left,norm_right,freq_bins_left,freq_bins_right] = get_normalized_compensations(compensationfilterfile);      % get the variables from an outsourced function that is executed below for both settings

            % interpolate power spectrum to get value at frequency Afreq
            Aamp_left  = amp * interp1(freq_bins_left, norm_left, frequency,'linear');
            Aamp_right = amp * interp1(freq_bins_right, norm_right, frequency,'linear');
        else
            Aamp_left  = amp;
            Aamp_right = amp;
        end

        stimuli{1}.command = 'gen_complex';
        stimuli{1}.parameters = sprintf('0,%f,1,%f,0,0,%f,%f',frequency,Aamp_left,stim_length, fs);
        stim(1).L = gen_waveform(stimuli);               % generate waveforms and return waveforms as a struct
        fprintf('DEBUG: max(abs(stim(1).L)): %1.3f mean: %1.3f stddev: %1.3f\n',max(abs(stim(1).L)),mean(stim(1).L),std(stim(1).L));
        stimuli{1}.parameters = sprintf('0,%f,1,%f,0,0,%f,%f',frequency,Aamp_right,stim_length, fs);
        stim(1).R = gen_waveform(stimuli);               % generate waveforms and return waveforms as a struct
        fprintf('DEBUG: max(abs(stim(1).R)): %1.3f mean: %1.3f stddev: %1.3f\n',max(abs(stim(1).R)),mean(stim(1).R),std(stim(1).R));
     case 'Mistuning'
        done = false;
        parameters = [];
        bestfrequency = [];
        while ~done
            in = input('Input the next BF in Hz, or <return> if there are no more: ');
            if isempty(in)
                done = true;
            else
                bestfrequency(end+1) = in;
                if length(bestfrequency) == 5
                    fprintf('Maximum of 5 best frequencies is reached\n')
                    done = true;
                end
            end
        end

        fprintf(fid,'  bestfrequency = [%s];',num2str(bestfrequency));   % store average BFs of each shank and recording site
        fprintf(fid,'  random_seed = %1.0f;',seed);                      % store which random seed was used
        fprintf(fid,'  F0s = [%s};',num2str(F0s'));                      % store current F0
        fprintf(fid,'  nharmonics = [%s];',num2str(nharmonics'));        % store number of components
        fprintf(fid,'  mistuned = [%s];',num2str(cell2mat(mistuned)));   % store which components of F0 to mistune
        fprintf(fid,'  freqshift = [%s];',num2str(freqshift));           % store mistunings to be applied
        fprintf(fid,'  level = %1.0f; % (dB SPL)\n',level);              % store level of calibration pure tone (dB SPL)
        amp = 20e-6*10.^(level/20);                                      % convert dB SPL to amplitude (Pascal)
        fprintf(fid,'  amplitude = %f; % (Pascal)\n',amp);               % store amplitude of calibration pure tone        
        fprintf(fid,'\n');                                               % return symbol
        
        if exist('compensationfilterfile','var') % have we been called with a compensation filter
            [norm_left, norm_right,freq_bins_left,freq_bins_right] = get_normalized_compensations(compensationfilterfile);     % get the variables from an outsourced function that is executed below for both settings
        end
        
        nsets = repetitions*length(F0s);         % save one file for each fundamental frequency
        n     = 0;                               % counter of current file
        for r=1:repetitions
            for f=1:length(F0s)                  % for each fundamental frequency
                n=n+1;
                fprintf('%s: Generate stimulus set %d out of %d\n',settings_parser,n,nsets);
                t   = clock;                               % get current time as vector [year month day hour minute seconds]
                stimuliL = struct([]);                      % generate an empty struct for left ear
                stimuliR = struct([]);                      % generate an empty struct for right ear

                s = 0;

                for b=1:length(bestfrequency)              % for each BF available at recording site
                    for m=1:length(mistuned{f})            % for each mistuned component
                        basefreq = bestfrequency(b) - F0s(f) * (mistuned{f}(m)-1);  % get basefreq that places mistuned component directly at the BF
                        basefreq = round(basefreq/F0s(f))*F0s(f);                   % we do harmonic complexes, quantize basefreq to be integer multiple of F0
                        if basefreq < F0s(f)               % is the BF of the current neuron to low
                            fprintf('skipped BF %1.1f Hz because too low and basefreq %1.1f < F0 %1.1f Hz\n',bestfrequency(b),basefreq, F0s(f));
                            continue;                      % then skip this mistuned component
                        end
                        %                         fprintf('BF:%d F0:%f mistuned:%d basefreq:%f\n',bestfrequency(b),F0s(f),mistuned{f}(m),basefreq);
                        for i=1:length(freqshift)
                            s=s+1;
                            stimuliL{s*2-1}.command = 'gen_complex';
                            stimuliR{s*2-1}.command = 'gen_complex';
                            shifts                  = zeros(1,nharmonics(f));
                            shifts(mistuned{f}(m))  = freqshift(i);
                            frequencies             = basefreq + (0:(nharmonics(f)-1))*F0s(f) + shifts;
                            if exist('compensationfilterfile','var')                % have we been called with a compensation filter
                                amps_left           = amp*interp1(freq_bins_left, norm_left, frequencies,'linear').*ones(1,nharmonics(f));
                                amps_right          = amp*interp1(freq_bins_right, norm_right, frequencies,'linear').*ones(1,nharmonics(f));
                            else
                                amps_left           = amp.*ones(1,nharmonics(f));
                                amps_right          = amp.*ones(1,nharmonics(f));
                            end

                            phases                    = zeros(1,nharmonics(f));
                            stimuliL{s*2-1}.parameters = sprintf('%f,%f,%d,[%s],[%s],[%s],%f,%f',F0s(f), basefreq, nharmonics(f), num2str(amps_left), num2str(shifts), num2str(phases), stim_length, fs);
                            stimuliL{s*2}.command      = 'gen_ISI';
                            stimuliL{s*2}.parameters   = sprintf('%s,%s',num2str(ISI),num2str(fs));
                            stimuliR{s*2-1}.parameters = sprintf('%f,%f,%d,[%s],[%s],[%s],%f,%f',F0s(f), basefreq, nharmonics(f), num2str(amps_right), num2str(shifts), num2str(phases), stim_length, fs);
                            stimuliR{s*2}.command      = 'gen_ISI';
                            stimuliR{s*2}.parameters   = sprintf('%s,%s',num2str(ISI),num2str(fs));
                            parameters(end+1).bestfrequency = bestfrequency(b);
                            parameters(end).stim_length     = stim_length;
                            parameters(end).ISI             = ISI;
                            parameters(end).F0              = F0s(f);
                            parameters(end).nharmonics      = nharmonics(f);
                            parameters(end).level           = level;
                            parameters(end).ampL            = amps_left(1);
                            parameters(end).ampR            = amps_right(1);
                            parameters(end).mistuned        = mistuned{f}(m);
                            parameters(end).freqshift       = freqshift(i);                            
                            parameters(end).basefreq        = basefreq;
                            parameters(end).phases          = phases;
                        end % for i (each freqshift)
                    end % for m (each mistuned component)
                end % for b (each BF)
                if dopermute
                    permidx = randperm(s);                      % get random permutation
                    fprintf(fid,'permutation_sequence = [%s];\n',num2str(permidx)); % log which permutation was used
                    idx = [permidx *2-1; permidx *2];           % always permute two commands (gen_complex + gen_ISI) together
                    stimuliL = stimuliL(idx(:));                % permute stimuli for left ear
                    stimuliR = stimuliR(idx(:));                % permute stimuli the same way for right ear
                    temp = parameters(end-s+1:end);
                    parameters(end-s+1:end) = temp(permidx);    % permute also last parameters
                end
                if isempty(stimuliL)                            % catch case where all components are below BF
                    n = n - 1;                                  % skip this set
                    continue
                end
                stim(n).L = gen_waveform(stimuliL);             % generate waveforms for left ear
                fprintf('DEBUG: max(abs(stim(%d).L)): %1.3f mean: %1.3f stddev: %1.3f\n',n,max(abs(stim(n).L)),mean(stim(n).L),std(stim(n).L));
                stim(n).R = gen_waveform(stimuliR);             % generate waveforms for right ear
                fprintf('DEBUG: max(abs(stim(%d).R)): %1.3f mean: %1.3f stddev: %1.3f\n',n,max(abs(stim(n).R)),mean(stim(n).R),std(stim(n).R));
            end % for f (each F0)
        end % for r (each repetiton)
        save(matfilename,'seed','parameters');
    case 'CalibrationDRCVowel'
        fprintf(fid,'  random_seed = %1.0f;\n',seed);             % store which random seed was used
        fprintf(fid,'  complex = [%s];',num2str(complex'));
        fprintf(fid,'  n_chord = %d',n_chord);
        fprintf(fid,'  jitter = [%s]',num2str(jitter'));
        fprintf(fid,'  levels_offset = %1.0f;',levels_offset);
        fprintf(fid,'  levels_range = %1.0f;',levels_range);
        fprintf(fid,'  freqs = [%s]',num2str(freqs));
        fprintf(fid,'  chord_duration = %1.0f',chord_duration);
        fprintf(fid,'  ramp_duration = %1.0f\n',ramp_duration);
        
        freqmat  = repmat(complex',1,n_chord);
        randmat  = ones(size(freqmat)) + (2*rand(size(freqmat))-1)*jitter;
        freqs    = freqmat.*randmat;
        levels   = rand(length(complex),n_chord*size(jitter,2))*levels_range+levels_offset; % example levels_range = 10 & levels_offset = 45 (=0..10+45) dB -> mean 50 dB with range [45,55]
        wave_drc = gen_drc(fs,freqs,levels,chord_duration,ramp_duration);
        if exist('compensationfilterfile','var')                % have we been called with a compensation filter
            fprintf('Applying compensation Filters...');
            load(compensationfilterfile);                       % get inverse filter as impulse response
            tic
            stim(1).L = fconv(compensationFilters.L,wave_drc);
            stim(1).R = fconv(compensationFilters.R,wave_drc);
            fprintf('done in %f secs.\n',toc);
        else
            stim(1).L = wave_drc;
            stim(1).R = wave_drc;
        end            
   case 'DRCvowel'
        fprintf(fid,'  random_seed = %1.0f;\n',seed);           % store which random seed was used
        fprintf(fid,'  ### vowel settings ###\n');
        fprintf(fid,'  vowel_dur = %1.0f;',vowel_dur);
        fprintf(fid,'  f0 = %1.0f;',f0);                        % store F0
        fprintf(fid,'  startvowel = [%s];',num2str(startvowel));
        fprintf(fid,'  endvowel = [%s];',num2str(endvowel));
        fprintf(fid,'  nsteps = %d;',nsteps);
        fprintf(fid,'  formants = %s;',num2str(formants'));
        fprintf(fid,'  bandwidths = [%s];',num2str(bandwidths));
        fprintf(fid,'  carriertype = %s;',carriertype);
        fprintf(fid,'  vowel_level = %1.0f;',vowel_level);
        vowel_amp = 20e-6*10.^(vowel_level/20);                 % convert dB SPL to amplitude (Pascal)
        fprintf(fid,'  vowel_amplitude = %f;\n',vowel_amp);     % store amplitude of calibration pure tone                
        fprintf(fid,'  vowel_position = [%s];\n',num2str(vowel_position'));
        fprintf(fid,'  ### DRC settings ###\n');
        fprintf(fid,'  complex = [%s];',num2str(complex));
        fprintf(fid,'  n_chord = %d',n_chord);
        fprintf(fid,'  jitter = [%s]',num2str(jitter'));
        fprintf(fid,'  levels_offset = %1.0f;',levels_offset);
        fprintf(fid,'  levels_range = %1.0f;',levels_range);
        fprintf(fid,'  chord_duration = %1.0f',chord_duration);
        fprintf(fid,'  ramp_duration = %1.0f\n',ramp_duration);

        if exist('compensationfilterfile','var')                % have we been called with a compensation filter
            load(compensationfilterfile);                       % get inverse filter as impulse response
        end            
        
        set_conditions = [];
        parameters = [];
        stim   = [];
        window = hann(ceil(fs*2*5e-3),'periodic');              % generate 5 ms Hann window
        window = window(round(end/2):end)';                     % we only need ramp down part (TODO: use better variable name)
        for j = 1:size(jitter,1)     % for all jitter combinations
            fprintf('Jitter %d/%d: [%s]\n',j,size(jitter,1),num2str(jitter(j,:)));
            % generate random jittered frequencies and levels
            fprintf('Create DRC');
            for b = 1:size(jitter,2)
                freqmat = repmat(complex',1,n_chord);
                randmat = ones(size(freqmat)) + (2*rand(size(freqmat))-1)*jitter(j,b);
                freqs_block{b} = freqmat.*randmat;
            end
            drc_freqs  = horzcat(freqs_block{:});
            drc_levels = rand(length(complex),n_chord*size(jitter,2))*levels_range+levels_offset; % example levels_range = 10 & levels_offset = 45 (=0..10+45) dB -> mean 50 dB with range [45,55]
           
            % do stimulus plot if true in line 15
            if dostimplot
               figure
               hold on
               mycolormap = jet(100);
               xlabel('time in s');
               ylabel('frequency in Hz');
               %axis tight
               for f = 1:size(drc_freqs,1)
                  for t = 1:size(drc_freqs,2)
                     plot([(t-1)*chord_duration+2.5e-3,t*chord_duration-2.5e-3],[drc_freqs(f,t),drc_freqs(f,t)],'LineWidth',3,'Color',mycolormap(ceil((drc_levels(f,t)-45)*10),:))                     
                  end
               end
            end
               
            wave_drc = gen_drc(fs,drc_freqs,drc_levels,chord_duration,ramp_duration);
            fprintf('done\n');

            % generate Vowel
            wav = [];
            for f = 1:size(formants,2)                % for all vowel morphing steps
                wave_vowel = gen_vowel(vowel_dur,vowel_amp,fs,f0,formants(:,f)',bandwidths,carriertype);
                for p = 1:length(vowel_position)      % for all positions within DRC
                    pos        = round( (ramp_duration/2 + chord_duration*(n_chord + vowel_position(p))) * fs);
                    wav{end+1} = wave_drc;            % copy DRC wave
                    wav{end}(pos:pos+length(wave_vowel)-1) = wav{end}(pos:pos+length(wave_vowel)-1) + wave_vowel;
                    wav{end}   = wav{end}(1:pos+length(wave_vowel)+round(fs));   % stop DRC 1s after vowel stopped
                    wav{end}(end-length(window)+1:end) = wav{end}(end-length(window)+1:end) .* window; % end with nice Han ramp down
                    wav{end}(end+round(fs)) = 0;                                 % add one second pause at end
                    
                    parameters(end+1).vowel_dur    = vowel_dur;
                    parameters(end).f0             = f0;
                    parameters(end).startvowel     = startvowel;
                    parameters(end).endvowel       = endvowel;
                    parameters(end).nsteps         = nsteps;
                    parameters(end).formants       = formants(:,f);
                    parameters(end).formants_id    = f;
                    parameters(end).bandwidths     = bandwidths;
                    parameters(end).carriertype    = carriertype;
                    parameters(end).vowel_level    = vowel_level;
                    parameters(end).vowel_amp      = vowel_amp;
                    parameters(end).vowel_position = vowel_position(p);
                    parameters(end).complex        = complex;
                    parameters(end).n_chord        = n_chord;
                    parameters(end).jitter         = jitter(j,:);
                    parameters(end).freqs          = freqs;
                    parameters(end).drc_freqs      = drc_freqs;
                    parameters(end).drc_levels     = drc_levels;
                    parameters(end).chord_duration = chord_duration;
                    parameters(end).ramp_duration  = ramp_duration;
                    parameters(end).levels_offset  = levels_offset;
                    parameters(end).levels_range   = levels_range;
                    parameters(end).drc_nsamples   = length(wav{end})-round(fs);
                    parameters(end).wav_nsamples   = length(wav{end});
                end % for p = 1:size(vowel_position)
            end % for f = 1:size(formants,2)
            
            % permute over all vowel morphing steps and positions within DRC
            permidx = randperm(length(wav));                                   % get random permutation
            fprintf(fid,'permutation_sequence = [%s];\n',num2str(permidx));    % log which permutation was used
            wav = wav(permidx);                                                % permute stimuli
            temp = parameters(end-length(wav)+1:end);
            parameters(end-length(wav)+1:end) = temp(permidx);                 % permute last parameters
            % return in separate waveforms that are <= 40 sec
            wav_lens = cellfun(@length,wav);
            i1 = 1;
            for i2=1:length(wav)
                if i2<length(wav)
%                     if sum(wav_lens(i1:i2))<40*fs
                    if sum(wav_lens(i1:i2))<32*fs % quickfix to avoid bug from line 258
                        continue
                    end
                    temp = [wav{i1:(i2-1)}];
                    set_conditions{end+1} = length(wav)*(j-1) + [i1 i2-1];
                else
                    temp = [wav{i1:i2}];  % TODO - bug that allows to be >40 sec if last stimulus is too long
                    set_conditions{end+1} = length(wav)*(j-1) + [i1 i2];
                end
                if exist('compensationFilters','var')               % do we have compensation filter available?
                    fprintf('Applying compensation Filters...');
                    tic
                    stim(end+1).L = fconv(compensationFilters.L,temp);
                    stim(end).R   = fconv(compensationFilters.R,temp);
                    fprintf('done in %f secs.\n',toc);
                    fprintf('done.\n');
                else
                    stim(end+1).L = temp;
                    stim(end).R   = temp;
                end            
            clear temp;
            i1 = i2;
            end % for i=1:length(wav)
        end % for j = 1:size(jitter,1)
%         stim = repmat(stim,[1 repetitions]);     % repeat derived wavefiles, benware will do permuation
%         ^^^--- will be done in benware (grid_DRCvowel.m, last line, grid.repeatsPerCondition)
        save(matfilename,'seed','parameters','set_conditions');
    otherwise
        error('Unknown settings parser "%s"',settings_parser);
end % switch settings_parser

fclose(fid);

end % function CreateAstridStimuli

function [norm_left, norm_right,freq_bins_left,freq_bins_right] = get_normalized_compensations(compensationfilterfile)

load(compensationfilterfile);                       % get inverse filter as impulse response
% log individual compensation levels
% To get an amplitude correction factor, Aamp, for frequency Afreq:

% get impulse response of compensation filter for left and right channel
left_IR  = compensationFilters.L;
right_IR = compensationFilters.R;

% get power spectrum of compensation filter
left_fourier  = abs(fft(left_IR));
right_fourier = abs(fft(right_IR));
left_fourier  = left_fourier(1:length(left_fourier)/2);
right_fourier = right_fourier(1:length(right_fourier)/2);

% get frequencies corresponding to power spectrum
%freq_bins_left  = linspace(0, grid.sampleRate/2, length(left_fourier));
%freq_bins_right = linspace(0, grid.sampleRate/2, length(right_fourier));
freq_bins_left  = linspace(0, 100000/2, length(left_fourier));
freq_bins_right = linspace(0, 100000/2, length(right_fourier));

% find maximal attenuation value of speaker in frequency region
% of interest and normalize
max_filtervalue_left = max(left_fourier(freq_bins_left<25e3));
max_filtervalue_right = max(right_fourier(freq_bins_right<25e3));
norm_left = left_fourier/max_filtervalue_left;
norm_right = right_fourier/max_filtervalue_right;

end