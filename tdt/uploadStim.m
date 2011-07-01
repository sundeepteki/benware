function uploadStim(stimDevice, stim, offset)
% Note it's also necessary to set nSamples for the new stimulus

%[offset offset+size(stim,2) getStimIndex]
if ~stimDevice.WriteTagV('WaveformL',offset,stim(1,:))
    errorBeep('WriteTagV WaveformL failed');
end
if ~stimDevice.WriteTagV('WaveformR',offset,stim(2,:))
    errorBeep('WriteTagV WaveformR failed');
end;
