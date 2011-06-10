function index = countData(chan)

global dataDevice;

index=dataDevice.GetTagVal(['ADidx' num2str(chan)]);
