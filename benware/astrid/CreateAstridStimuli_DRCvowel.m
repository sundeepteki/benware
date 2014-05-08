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
    % generate random jittered frequencies and levels, frequency jitter is plus/minus, i.e. frequencies rove below and above around nominal frequency
    fprintf('Create DRC');
    for b = 1:size(jitter,2)  % for all jitter values
        freqmat = repmat(complex',1,n_chord);
        randmat = ones(size(freqmat)) + (2*rand(size(freqmat))-1)*jitter(j,b);
        freqs_block{b} = freqmat.*randmat;
    end
    drc_freqs  = horzcat(freqs_block{:});
    drc_levels = rand(length(complex),n_chord*size(jitter,2))*levels_range+levels_offset; % example levels_range = 10 & levels_offset = 45 (=0..10+45) dB -> mean 50 dB with range [45,55]

    % do stimulus plot if true in line 15
    %             if dostimplot
    %                fig_drc = figure;                 % remember handle to figure to copy it later to paint different formants ontop of it
    %                hold on
    %                mycolormap = jet(100);
    %                xlabel('time in s','FontSize',14);
    %                ylabel('frequency in Hz','FontSize',14);
    %                for f = 1:size(drc_freqs,1)
    %                   for t = 1:size(drc_freqs,2)
    %                      plot([(t-1)*chord_duration+2.5e-3,t*chord_duration-2.5e-3],[drc_freqs(f,t),drc_freqs(f,t)],'LineWidth',3,'Color',mycolormap(ceil((drc_levels(f,t)-45)*10),:));
    %                   end
    %                end
    %                set(gca,'FontSize',14);
    %                axis tight
    %                print('-dpng','DRCstimulus.png');
    %                saveas(gcf,'DRCstimulus.fig','fig');
    %             end
    wave_drc = gen_drc(fs,drc_freqs,drc_levels,chord_duration,ramp_duration);
    %             if dostimplot
    %                wavwrite(wave_drc,round(fs),'DRCstimulus.wav');
    %             end
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
            if dostimplot
                %                        if f == 1                         % we don't plot the different formant freqs at the moment
                %                           fig = figure();                % open new figure
                %                           figure(fig_drc);               % go to DRC plot
                %                           copyobj(gca,fig);              % copy DRC plot in our new figure
                %                           figure(fig);                   % use our new figure with freshly copied DRC plot for upcoming plots
                %                           pos = (ramp_duration/2 + chord_duration*(n_chord + vowel_position(p)));  % get position of current vowel
                %                           for freq = 220:220:(27*220)    % plot from 220 to 5940 Hz
                %                              plot([pos pos+vowel_dur],[freq freq],'k-','LineWidth',3);
                %                           end % i
                %                           print('-dpng',sprintf('DRCstimulus_vowelpos%d.png',vowel_position(p)));
                %                           saveas(gcf,sprintf('DRCstimulus_vowelpos%d.fig',vowel_position(p)),'fig');
                %                          close(fig);
                %                       end
                wavwrite(wav{end}(1:end-round(fs)),round(fs),sprintf('DRCvowel_JT%1.3f_%1.3f_Pos%d_F%d.wav',jitter(j,1),jitter(j,2),vowel_position(p),f));
            end
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

