function resetDevices(tdt)

fprintf('== Resetting devices...');
resetStimDevice(tdt.stimDevice);
resetDataDevice(tdt.dataDevice);
fprintf('done\n');
