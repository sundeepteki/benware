function tdt = prepareTDT(tdt, expt, grid)
% tdt = prepareTDT(tdt, expt, grid)
%
% Given expt and grid structures, set the TDT up appropriately.
% 
% tdt: A previously initialised tdt structure, or []
% expt, grid: Standard benWare structures
% 
% Returns:
% tdt.zBus -- zBus handle
% tdt.stimDevice -- stimulus device handle
% tdt.stimSampleRate -- stimulus device sample rate
% tdt.dataDevice -- data device handle
% tdt.dataSampleRate -- data device sample rate

f=figure(103);
set(f,'color',[1 1 1], 'name', 'TDT', 'numbertitle', 'off', ...
  'toolbar', 'none', 'menubar', 'none', 'visible', 'off');
set_fig_size(100, 1, 103);
put_fig_in_bottom_right;

if isempty(tdt)
  tdt = struct();
end

% if ~isfield(tdt,'stimDevice')
%   tdt.stimDevice = [];
% end
% [tdt.stimDevice, tdt.stimSampleRate] = ...
%   stimDeviceInit(tdt.stimDevice, expt.stimDeviceName, grid.sampleRate,  ...
%                   grid.monoStim);
% 
% if ~isfield(tdt,'dataDevice')
%   tdt.dataDevice = [];
% end
% 
% [tdt.dataDevice, tdt.dataSampleRate] = ...
%   dataDeviceInit(tdt.dataDevice, expt.dataDeviceName, ...
%   expt.dataDeviceSampleRate, expt.channelMapping, tdt.stimDevice);
if grid.monoStim
    nStimChannels = 1;
else
    nStimChannels = 2;
end
tdt.stimDevice = feval(expt.stimDeviceType, expt.stimDeviceName, grid.sampleRate, nStimChannels);
tdt.dataDevice = feval(expt.dataDeviceType, expt.dataDeviceName, expt.dataDeviceSampleRate, expt.channelMapping);

if strcmp(expt.triggerDevice, 'stimDevice')
    tdt.triggerDevice = tdt.stimDevice;
elseif strcmpi(expt.triggerDevice, 'zbus')
    tdt.triggerDevice = zBus();
else
    errorBeep('Unknown trigger type');
end

% if ~isfield(tdt,'zBus')
%   tdt.zBus = [];
% end
% tdt.zBus = zBusInit(tdt.zBus, tdt.stimDevice, tdt.dataDevice);
% 

fprintf('  * Post-initialisation pause...');
pause(2);
fprintf('done.\n');

% check sample rates are identical to those requested
if tdt.stimDevice.sampleRate ~= grid.sampleRate
  errorBeep('stimDevice sample rate is wrong');
end

if tdt.dataDevice.sampleRate ~= expt.dataDeviceSampleRate
  errorBeep('dataDevice sample rate is wrong');
end
