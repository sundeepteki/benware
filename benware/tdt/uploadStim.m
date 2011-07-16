function uploadStim(stimDevice, stim, offset)
% Note it's also necessary to set nSamples for the new stimulus

%[offset offset+size(stim,2) getStimIndex]
%if ~stimDevice.WriteTagV('WaveformL',offset,stim(1,:))
%    errorBeep('WriteTagV WaveformL failed');
%end
%if ~stimDevice.WriteTagV('WaveformR',offset,stim(2,:))
%    errorBeep('WriteTagV WaveformR failed');
%end;

maxRetries = 2;

nRetries = 0;
success = false;

while ~success && nRetries<maxRetries
  success = stimDevice.WriteTagV('WaveformL',offset,stim(1,:));
  if ~success
    fprintf('== WriteTagV WaveformL failed\n');
    nRetries = nRetries + 1;
  end
end

if ~success
  errorBeep('Giving up after 3 attempts!');
end

nRetries = 0;
success = false;

while ~success && nRetries<maxRetries
  success = stimDevice.WriteTagV('WaveformR',offset,stim(2,:));
  if ~success
    fprintf('== WriteTagV WaveformR failed\n');
    nRetries = nRetries + 1;
  end
end

if ~success
  errorBeep('Giving up after 3 attempts!');
end
