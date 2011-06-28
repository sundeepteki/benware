function index = countAllData(dataDevice)
% index = countAllData()

index = nan(1, 32);
for chan = 1:32
    index(chan) = dataDevice.GetTagVal(['ADidx' num2str(chan)]);
end
