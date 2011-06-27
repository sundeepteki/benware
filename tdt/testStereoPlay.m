% test calib play
device = deviceInit([], 'RX6', 'tdt/stereoplay.rcx', 'StereoPlayVer', 1, 50000);

device.WriteTagV('WaveformL',0,1*rand(1,500000)-2)
device.WriteTagV('WaveformR',0,1*rand(1,500000)-2)
device.SetTagVal('nSamples',100000);
pause(2);
device.SoftTrg(1)
tic;
while toc<4
  fprintf('%1.2f %d %d\n',toc,device.GetTagVal('StimIndex'),device.GetCycUse);
  pause(0.5);
end