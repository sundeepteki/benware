function tdt = prepareTDT(tdt, expt, grid)
% prepare TDT

figure(99);
set_fig_size(100, 100, 99);
put_fig_in_bottom_right;

if isempty(tdt)
  tdt = struct();
end

if ~isfield(tdt,'zBus')
  tdt.zBus = [];
end
tdt.zBus = zBusInit(tdt.zBus);

if ~isfield(tdt,'stimDevice')
  tdt.stimDevice = [];
end
[tdt.stimDevice, tdt.stimSampleRate] = stimDeviceInit(tdt.stimDevice, expt.stimDeviceName, grid.sampleRate);

if ~isfield(tdt,'dataDevice')
  tdt.dataDevice = [];
end
[tdt.dataDevice, tdt.dataSampleRate] = dataDeviceInit(tdt.dataDevice, expt.dataDeviceName, expt.dataDeviceSampleRate, expt.channelMapping);

fprintf('  * Post-initialisation pause...');
pause(2);
fprintf('done.\n');

% check sample rates are identical to those requested
if tdt.stimSampleRate ~= grid.sampleRate
  error('stimDevice sample rate is wrong');
end

if tdt.dataSampleRate ~= expt.dataDeviceSampleRate
  error('dataDevice sample rate is wrong');
end