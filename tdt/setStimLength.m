function setStimLength(stimDevice, samples)

if ~stimDevice.SetTagVal('nSamples', samples)
    error('WriteTag nSamples failed');
end;
