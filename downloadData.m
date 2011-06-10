function data = downloadData(chan, start)

global dataDevice;

index=dataDevice.GetTagVal(['ADidx' num2str(chan)]);
data=dataDevice.ReadTagVEX(['ADwb' num2str(chan)],start,index-start,'F32','F64',1);
