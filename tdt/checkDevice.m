function [ok, message] = checkDevice(device, sampleRateHz, versionTagName, version)

ok = true;
message = '';

if device.GetTagVal(versionTagName)~=version
  ok = false;
  message = 'wrong circuit loaded';
elseif device.GetSFreq~=sampleRateHz
  ok = false;
  message = ['wrong sample rate -- ' num2str(device.GetSFreq)];
elseif bitand(device.GetStatus,7)~=7
  ok = false;
  message = ['reports wrong status -- code ' bitand(device.GetStatus,7)];
end
