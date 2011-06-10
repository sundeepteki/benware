function stim = downloadStim(nSamples)

global stimDevice;

stim(1,:)=stimDevice.ReadTagVEX('Waveform1',0,nSamples,'F32','F64',1);
stim(2,:)=stimDevice.ReadTagVEX('Waveform2',0,nSamples,'F32','F64',1);
