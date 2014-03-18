function [stim, stimInfo] = prepareStimulus(stimGenerationFunction, sweepNum, grid, expt)
% generate stimInfo (stimulus parameters) for a given sweep, and
% pass parameters to specified stimGenerationFunction which generates
% stimulus vectors.
% Finally, add stimLevelOffsetDB to the stimulus for absolute calibration

global OLDCOMPENSATION

if OLDCOMPENSATION
    stimInfo.stimGridTitles = grid.stimGridTitles;
    stimInfo.stimParameters = grid.randomisedGrid(sweepNum, :);

    parameters = num2cell(stimInfo.stimParameters);

    % generate stimulus vector/matrix
    stim = feval(stimGenerationFunction, expt, grid, grid.sampleRate, expt.nStimChannels, ...
                    grid.compensationFilters, parameters{:});

    % check number of channels is correct
    if size(stim, 1)~=expt.nStimChannels
        errorBeep('Stimulus function %s did not generate the correct number of channels (%d)', ...
                    func2str(stimGenerationFunction), expt.nStimChannels);
    end

    % apply relative and absolute compensation

    % apply level offset
    level_offset = grid.stimLevelOffsetDB;
    if length(level_offset)==1
        level_offset = repmat(level_offset, 1, size(stim, 1));
    end

    for chan = 1:size(stim, 1)
      stim(chan, :) = stim(chan, :) * 10^(level_offset(chan) / 20);
    end

else
    stimInfo.stimGridTitles = grid.stimGridTitles;
    stimInfo.stimParameters = grid.randomisedGrid(sweepNum, :);
    
    parameters = num2cell(stimInfo.stimParameters);

    % generate stimulus vector/matrix
    uncomp = feval(stimGenerationFunction, expt, grid, grid.sampleRate, expt.nStimChannels, ...
                    grid.compensationFilters, parameters{:});

    % check number of channels is correct
    if size(uncomp, 1)~=expt.nStimChannels
        errorBeep('Stimulus function %s did not generate the correct number of channels (%d)', ...
                    func2str(stimGenerationFunction), expt.nStimChannels);
    end
    
    % at this point, stim is equal to the ideal stimulus, i.e.
    % it has not been processed with the headphone compensation or the
    % absolute level compensation.
    % So, the stimulus can be checked here (e.g. the RMS level)
    
    % check maximum level of stimulus in 5ms increments
    std_n = round(.005*grid.sampleRate);
    l = size(uncomp, 2);
    total_n = floor(l/std_n)*std_n;
    sd = nan(1, size(uncomp, 1));
    for ii = 1:size(uncomp, 1)
      r = reshape(uncomp(ii,1:total_n), [std_n total_n/std_n]);
      sd(ii) = max(std(r));
    end
    max_level = 20*log10(sd)+94;
    
    fprintf(['  * maximum levels: [ ' num2str(max_level, '%0.2f '), ' ]\n']);

    if max_level>110
        errorBeep('== Warning: maximum sound level is >110dB');
    end
    
    
    % apply relative and absolute compensation
    if grid.applyCompensationFilters
        stim = {};
        for chan = 1:expt.nStimChannels
            if chan<=length(grid.compensationFilters)
                % then this is assumed to be a compensatable audio channel
                % (not a pure voltage for driving the LED for example)
                fprintf('= Compensating for frequency response\n');
                stim{chan} = conv(grid.compensationFilters{chan}, uncomp(chan,:));
                if isfield(grid, 'legacyLevelOffsetDB')
                    if length(grid.legacyLevelOffsetDB)==1
                        level_offset = grid.legacyLevelOffsetDB(1);
                    else
                        level_offset = grid.legacyLevelOffsetDB(chan);
                    end
                    stim{chan} = stim{chan} * 10^(level_offset / 20);
                    fprintf('= LegacyLevelOffset: boosting level by %d db\n', level_offset);

                end
            else
               % pure voltage channels may need some padding at the end
               stim{chan} = zeros(1, max(cellfun(@(x) length(x),a)));
               stim{chan}(1:length(uncomp(chan,:))) = uncomp(chan,:);
            end
        end
        stim = cat(1, stim{:});
    else
        stim = uncomp;
    end
    %
    if false
       keyboard
       l = load(expt.compensationFilterFile);
       play_and_analyse_sound(grid.sampleRate, 1, 'RX6', uncomp(2,:), grid.compensationFilters{2}, 50, l.calibs(1).reftone_rms_volts_per_pascal);
       play_and_analyse_sound(grid.sampleRate, 1, 'RX6', stim(2,:), [], 50, l.calibs(1).reftone_rms_volts_per_pascal);
       keyboard
    end
end    