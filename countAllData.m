function index = countData

global dataDevice;

for chan = 1:32
    index(chan)=dataDevice.GetTagVal(['ADidx' num2str(chan)]);
end
