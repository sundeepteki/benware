function [ok, message] = checkDevice(device, sampleRateHz, ...
  versionTagName, versionTagValue)
% [ok, message] = checkDevice(device, sampleRateHz, versionTagName, version)
% 
% Check whether a TDT device is in the desired state. If not, return ok=false
% and provide an explanatory message that a calling function can print to
% the screen.
%
% device: handle to the device
% sampleRateHz: the sample rate you want
% versionTagName: the name of a tag in the RCX file that we're using to 
%   store a circuit version number
% versionTagValue: the version number expected

ok = true;
message = '';

if device.GetTagVal(versionTagName)~=versionTagValue
  ok = false;
  message = 'wrong circuit loaded';
elseif device.GetSFreq~=sampleRateHz
  ok = false;
  message = ['wrong sample rate -- ' num2str(device.GetSFreq)];
elseif bitand(device.GetStatus,7)~=7
  ok = false;
  message = ['reports wrong status -- code ' bitand(device.GetStatus,7)];
end
