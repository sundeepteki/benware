function updateFakeStimDevice(timerObj, event, device)

t = (now-device.triggerTime)*24*3600;
maxSamples = floor(device.recdur/1000*device.sampleRate)+1;
nSamples = min(maxSamples, floor(t * device.sampleRate));
device.ADidx = repmat(nSamples,1, 128);

if all(device.ADidx==maxSamples)
  stop(device.timer);
  device.timer = [];
  device.triggerTime = -1;
end