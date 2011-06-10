function uploadStimulus(stim,offset)

global stimDevice
%[offset offset+size(stim,2) getStimIndex]
if invoke(stimDevice,'WriteTagVex','WaveForm1',offset,'F32',stim(1,:)) == 0,
    error('WriteTagVEX WaveForm1 failed');
end;
if invoke(stimDevice,'WriteTagVex','WaveForm2',offset,'F32',stim(2,:)) == 0,
    error('WriteTagVEX WaveForm2 failed');
end;
