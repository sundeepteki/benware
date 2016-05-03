% test

stimDevice.type = 'tdtStimDevice';
stimDevice.name = 'RX6';
stimDevice.sampleRate = 48828.125;
stimDevice.nChannels = 2;

tdtDevice = feval(stimDevice.type, stimDevice.name, stimDevice.sampleRate, stimDevice.nChannels);



stimDevice.type = 'playrecStimDevice';
stimDevice.name = 'MOTU Audio ASIO';
stimDevice.sampleRate = 88200;
stimDevice.nChannels = 2;

motuDevice = feval(stimDevice.type, stimDevice.name, stimDevice.sampleRate, stimDevice.nChannels);

% 
% device = tdtDevice('RX6', '../tdt/StereoPlay.rcx', 'StereoPlayVer', 5, ...
%                    48828.125);
% 
% device.initialise('RX6', '../tdt/StereoPlay.rcx', 'StereoPlayVer', 5, ...
%    48828.125);
% 
% 
% device = tdtStimDevice('RX6', 48828.125, 2);
% 
% device.initialise('RX6', '../tdt/StereoPlay.rcx', 'StereoPlayVer', 5, ...
%    48828.125);
% 
% 
% dataDevice = tdtDataDevice('RZ2', 48828.125/2, [1:32]);