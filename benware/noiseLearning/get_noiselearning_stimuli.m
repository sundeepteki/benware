function stim = get_noiselearning_stimuli(expt, grid, sampleRate, nChannels, compensationFilters, ...
                    ID, level);
                
global noiseTokens;

if ID==1
    stim = noiseTokens.screeningStimulus;
 
elseif ID==2
    stim = noiseTokens.AStimulus;

elseif ID==3
    stim = noiseTokens.BStimulus;
    
end
stim = [stim; stim];

% apply level offset
level_offset = level-80;
stim = stim * (10^(level_offset) / 20);
