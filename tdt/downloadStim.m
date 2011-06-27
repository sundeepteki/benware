function stim = downloadStim(stimDevice, offset,nSamples)

stim(1,:)=stimDevice.ReadTagVEX('Waveform1',offset,nSamples,'F32','F64',1);
stim(2,:)=stimDevice.ReadTagVEX('Waveform2',offset,nSamples,'F32','F64',1);
