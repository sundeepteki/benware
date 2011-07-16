function index = countData(dataDevice, chan)
% index = countData(dataDevice, chan)
%
% Count number of samples available on a specified channel of the 
% data device
%
% dataDevice: handle of the data device
% chan: the number of the channel you want
% index: the index that the serial buffer has reached

index=dataDevice.GetTagVal(['ADidx' num2str(chan)]);
