function updateFakeStimDevice(timerObj, event, device)

t = (now-device.triggerTime)*24*3600;
device.StimIndex = min(device.nSamples, floor(t * device.sampleRate));

if device.StimIndex==device.nSamples
  stop(device.timer);
  device.timer = [];
  device.triggerTime = -1;
end