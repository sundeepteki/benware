function data = downloadAllData(dataDevice, nChannels)
% data = downloadAllData(dataDevice, nChannels)
%
% Download all available data from data device
% 
% dataDevice: handle of the data device
% nChannels: number of channels that you want data from
% data: cell array of data from those channels

for chan = 1:nChannels
    maxIndex=dataDevice.GetTagVal(['ADidx' num2str(chan)]);
    data{chan}=dataDevice.ReadTagV(['ADwb' num2str(chan)],0,maxIndex);
end
