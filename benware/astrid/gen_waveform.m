function waveform = gen_waveform(stimuli)
% gen_waveform() -- generates concatenated waveform defined by list of stimulus generators
%   Usage:
%      waveform = gen_waveform(stimuli)
%   Parameters:
%      stimuli     struct containing stimulus generators
%   Outputs:
%      waveform    vector containing all waveforms of the set concatenated
%
% Author: stef@nstrahl.de
% Version: $Id: gen_waveform.m 113 2013-08-12 23:22:39Z stefan $

waveforms = struct([]);           % generate an empty struct
for g=1:length(stimuli)
    try
        eval(['waveforms{g} = ' stimuli{g}.command '(' stimuli{g}.parameters ');']);
    catch me
        me                        % show what exception occured
        keyboard                  % allow to debug in case of errors
    end
end
waveform = [waveforms{:}];        % concatenate all single waveforms