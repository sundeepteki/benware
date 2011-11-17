function stim = downloadStim(stimDevice, offset, nSamples, nStimChans)

stim(1,:)=stimDevice.ReadTagV('WaveformL',offset,nSamples);
if nStimChans==2
  stim(2,:)=stimDevice.ReadTagV('WaveformR',offset,nSamples);
end
