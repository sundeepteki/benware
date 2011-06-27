function index = countData(dataDevice, chan)

index=dataDevice.GetTagVal(['ADidx' num2str(chan)]);
