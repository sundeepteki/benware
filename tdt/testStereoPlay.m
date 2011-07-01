% test calib play
device = deviceInit([], 'RX6', 'tdt/stereoplay.rcx', 'StereoPlayVer', 3, 50000);
zBus = zBusInit([]);

load handel;
y = resample(y,40000,8000);
device.WriteTagV('WaveformL',0,y'*2)
device.WriteTagV('WaveformR',0,y'*2)
device.SetTagVal('nSamples',length(y));
fprintf('No sound yet\n');
pause(5);
fprintf('Sound\n');

triggerZBus(zBus);

tic;
while toc<2
  fprintf('%1.2f %d %d\n',toc,device.GetTagVal('StimIndex'),device.GetCycUse);
  pause(0.5);
end
