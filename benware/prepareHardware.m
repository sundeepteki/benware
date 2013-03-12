function hardware = prepareHardware(hardware, expt, grid)
% hardware = prepareHardware(hardware, expt, grid)
%
% Given expt and grid structures, set the hardware up appropriately.
% 
% hardware: A previously initialised hardware structure, or []
% expt, grid: Standard benWare structures
% 
% Returns:
% hardware.zBus -- zBus handle
% hardware.stimDevice -- stimulus device handle
% hardware.stimSampleRate -- stimulus device sample rate
% hardware.dataDevice -- data device handle
% hardware.dataSampleRate -- data device sample rate


if isempty(hardware)
  hardware = struct();
end

% Set up stim device
% we want to be able to have mono or stereo stimulus device because the amount of buffer space on the 
% TDT devices is limited. We don't want to share the buffer with a non-existant second channel.

if ~isfield(hardware, 'stimDevice')
	ok = false;
	message = '';
elseif ~strcmp(class(hardware.stimDevice), expt.stimDeviceType)
	ok = false;
	message = fprintf('wrong stimulus device type (%s rather than %s)', ...
		class(hardware.stimDevice), expt.stimDeviceType);
else
	[ok, message] = hardware.stimDevice.checkDevice(expt.stimDeviceName, grid.sampleRate, expt.nStimChannels);
end

if ~ok
	fprintf('Reinitialising stimulus device (%s)...\n', message);
	hardware.stimDevice = feval(expt.stimDeviceType, ...
								expt.stimDeviceName, grid.sampleRate, expt.nStimChannels);
end

% set up data device
if ~isfield(hardware, 'dataDevice')
	ok = false;
	message = '';
elseif ~strcmp(class(hardware.dataDevice), expt.dataDeviceType)
	ok = false;
	message = fprintf('wrong data device type (%s rather than %s)', ...
		class(hardware.dataDevice), expt.dataDeviceType);
else
	[ok, message] = hardware.dataDevice.checkDevice(expt.dataDeviceName, expt.dataDeviceSampleRate, ...
					            expt.channelMapping);
end

if ~ok
    if ~isempty(message)
    	fprintf('Reinitialising data device (%s)...\n', message);
    end
	hardware.dataDevice = feval(expt.dataDeviceType, expt.dataDeviceName, expt.dataDeviceSampleRate, ...
					            expt.channelMapping, hardware.stimDevice);
end

% set up trigger
if strcmpi(expt.triggerDevice, 'stimDevice')
    hardware.triggerDevice = hardware.stimDevice;
elseif strcmpi(expt.triggerDevice, 'zBus')
    if ~isfield(hardware, 'triggerDevice') || ~strcmp(class(hardware.triggerDevice), expt.triggerDevice)
        hardware.triggerDevice = zBus();
    end
elseif strcmpi(expt.triggerDevice, 'stimAndDataDevices')
  hardware.triggerDevice = stimAndDataTrigger(hardware.stimDevice, hardware.dataDevice);
else
    errorBeep('Unknown trigger type');
end

fprintf('  * Post-initialisation pause...');
pause(2);
fprintf('done.\n');

% check sample rates are identical to those requested
if hardware.stimDevice.sampleRate ~= grid.sampleRate
  errorBeep('stimDevice sample rate is wrong');
end

if hardware.dataDevice.sampleRate ~= expt.dataDeviceSampleRate
  errorBeep('dataDevice sample rate is wrong');
end
