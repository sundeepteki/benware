function initExpt
% function initExpt
%
% make a completely new expt structure
% this is more an example than anything else -- you should normally
% just use newExpt to update your old expt structure
% and you can always edit it by hand anyway

expt.stimDeviceName = 'RX6';
expt.dataDeviceName = 'RZ5';
expt.dataDeviceSampleRate = 24414.0625;

channelMapping = [9 8 10 7 13 4 12 5 15 2 16 1 14 3 11 6];
expt.channelMapping = [channelMapping channelMapping+16];

expt.dataRoot = 'E:\auditory-objects.data\';

expt.exptNum = 0;
expt.penetrationNum = 0;
expt.headstage.lhs = 0;
expt.headstage.rhs = 0;
expt.probe.lhs = 0;
expt.probe.rhs = 0;

if exist('expt.mat', 'file')
  movefile expt.mat expt.mat.old
end

save expt.mat expt