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
                    %fprintf('skipped BF %1.1f Hz because too low and basefreq %1.1f < F0 %1.1f Hz\n',bestfrequency(b),basefreq, F0s(f));
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
        %fprintf('DEBUG: max(abs(stim(%d).L)): %1.3f mean: %1.3f stddev: %1.3f\n',n,max(abs(stim(n).L)),mean(stim(n).L),std(stim(n).L));
        stim(n).R = gen_waveform(stimuliR);             % generate waveforms for right ear
        %fprintf('DEBUG: max(abs(stim(%d).R)): %1.3f mean: %1.3f stddev: %1.3f\n',n,max(abs(stim(n).R)),mean(stim(n).R),std(stim(n).R));
    end % for f (each F0)
end % for r (each repetiton)
save(matfilename,'seed','parameters');
