function index = countAllData(dataDevice, nChannels)
% index = countAllData(dataDevice, nChannels)
%
% Count the number of samples available on each channel of the data Device
% i.e. the index that the serial buffers have reached
% 
% dataDevice: A handle to the data device
% nChannels: The number of channels that you want information about
% index: 1xnChannels vector of buffer indexes

index = nan(1, nChannels);
for chan = 1:nChannels
    index(chan) = dataDevice.GetTagVal(['ADidx' num2str(chan)]);
end
