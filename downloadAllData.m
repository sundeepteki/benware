function dataCell = downloadAllData

global dataDevice;

for chan = 1:32
    index=dataDevice.GetTagVal(['ADidx' num2str(chan)]);
    dataCell{chan}=dataDevice.ReadTagVEX(['ADwb' num2str(chan)],0,index,'F32','F64',1);
end
