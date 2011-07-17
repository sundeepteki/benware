function updateFakeStimDevice(timerObj, event, device)

t = (now-device.triggerTime)*24*3600;
maxSamples = floor(device.recdur*device.sampleRate)+1;
nSamples = min(maxSamples, floor(t * device.sampleRate));
device.ADidx = repmat(nSamples,1,32);

if all(device.ADidx==maxSamples)
  stop(device.timer);
  device.timer = [];
  device.triggerTime = -1;
end