%% initial setup

global zBus stimDevice dataDevice;
fs_in = 24414.0625;
fs_out = fs_in*2;

zBusInit;
stimulusDeviceInit('RX6',50);
dataDeviceInit;
pause(2);


stim = loadStimulus(tic;
fprintf('== SWEEP START\n');

runSweep()
saveData()

fprintf(['== FINISHED AFTER ' num2str(toc) ' sec.\n\n']);
%return
