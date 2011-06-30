function index = countData(dataDevice, chan)
% index = countData(dataDevice, chan)
%
% Count number of samples available on a specified channel of the 
% data device
index=dataDevice.GetTagVal(['ADidx' num2str(chan)]);
