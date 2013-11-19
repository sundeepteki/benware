function updateFakeStimDevice(timerObj, event, device)

t = (now-device.triggerTime)*24*3600;
device.stimIndex = min(device.nSamples, floor(t * device.sampleRate));

if device.stimIndex==device.nSamples
  stop(device.timer);
  device.timer = [];
  device.triggerTime = -1;
end