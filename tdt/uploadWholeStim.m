function uploadWholeStim(stimDevice, stim)
% uploadWholeStimulus(stimDevice, stim)
%
% Upload a stereo stimulus to stimDevice, and inform the device
% about the stimulus length

if ~stimDevice.SetTagVal('nSamples',size(stim,2))
    error('WriteTag nSamples failed');
end

if ~stimDevice.WriteTagV('WaveformL',0,stim(1,:))
    error('WriteTagV WaveformL failed');
end

if ~stimDevice.WriteTagV('WaveformR',0,stim(2,:))
    error('WriteTagV WaveformR failed');
end
