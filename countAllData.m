function index = countAllData()
% index = countAllData()

global dataDevice;

index = nan(1, 32);
for chan = 1:32
    index(chan) = dataDevice.GetTagVal(['ADidx' num2str(chan)]);
end
