function uploadWholeStimulus(stim)

global stimDevice

if invoke(stimDevice,'SetTagVal','NumPoints',size(stim,2)) == 0,
    error('WriteTag NumPoints failed');
end;
if invoke(stimDevice,'WriteTagVex','WaveForm1',0,'F32',stim(1,:)) == 0,
    error('WriteTagVEX WaveForm1 failed');
end;
if invoke(stimDevice,'WriteTagVex','WaveForm2',0,'F32',stim(2,:)) == 0,
    error('WriteTagVEX WaveForm2 failed');
end;

% soft trigger needed here?
invoke(stimDevice,'SoftTrg',9);
