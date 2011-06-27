function stim = downloadStim(stimDevice, offset,nSamples)

stim(1,:)=stimDevice.ReadTagV('WaveformL',offset,nSamples);
stim(2,:)=stimDevice.ReadTagV('WaveformR',offset,nSamples);
