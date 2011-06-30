function index = countAllData(dataDevice)
% index = countAllData(dataDevice)
%
% Count the number of samples available on each channel of the data Device

index = nan(1, 32);
for chan = 1:32
    index(chan) = dataDevice.GetTagVal(['ADidx' num2str(chan)]);
end
