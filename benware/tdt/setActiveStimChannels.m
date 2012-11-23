function setActiveStimChannels(stimDevice, nChannels)

stimDevice.SetTagVal('LeftActive', 1);

if nChannels==1
  stimDevice.SetTagVal('RightActive', 0);
else
  stimDevice.SetTagVal('RightActive', 1);    
end