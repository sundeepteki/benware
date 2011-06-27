function [ok, message] = checkStimDevice(sampleRateHz,stereoPlayVersion)

error('Deprecated... doing nothing');
return

global stimDevice

ok = true;
message = '';

if stimDevice.GetTagVal('StereoPlayVer')~=stereoPlayVersion
  ok = false;
  message = 'wrong circuit loaded';
elseif stimDevice.GetSFreq~=sampleRateHz
  ok = false;
  message = ['wrong sample rate -- ' num2str(stimDevice.GetSFreq)];
elseif bitand(stimDevice.GetStatus,7)~=7
  ok = false;
  message = ['reports wrong status -- code ' bitand(stimDevice.GetStatus,7)];
end
