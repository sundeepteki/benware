function setStimulusLength(stimDevice, samples)

error('Deprecated! Doing nothing');
return;

if ~stimDevice.SetTagVal('NumPoints',samples)
    error('WriteTag NumPoints failed');
end;

% reset circuit
stimDevice.SoftTrg(9);
