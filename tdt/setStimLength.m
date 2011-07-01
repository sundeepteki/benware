function setStimLength(stimDevice, samples)

if ~stimDevice.SetTagVal('nSamples', samples)
    errorBeep('WriteTag nSamples failed');
end;
