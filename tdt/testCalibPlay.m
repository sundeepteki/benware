% test calib play
device = deviceInit([], 'RX6', 'tdt/calibPlay.rcx', 'CalibPlayVer', 1, 100000);

load('d:\auditory-objects\calibration\calib.expt30\compensationFilters.mat');
%b = fir1(1024,.9);
len = 1024;
offset = (length(compensationFilters.L)-len)/2+1;
filterL = compensationFilters.L(offset:offset+len);
filterR = compensationFilters.R(offset:offset+len);
device.WriteTagV('FilterL',0,filterL)
device.WriteTagV('FilterR',0,filterR)
device.WriteTagV('Waveform',0,1*rand(1,50000))
device.SetTagVal('numPoints',5000);
device.SoftTrg(1)
tic;
while toc<4
  fprintf('%1.2f %d %d\n',toc,device.GetTagVal('StimIndex'),device.GetCycUse);
  pause(0.5);
end