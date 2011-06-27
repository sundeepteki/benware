function data = downloadAllData(dataDevice)

for chan = 1:32
    maxIndex=dataDevice.GetTagVal(['ADidx' num2str(chan)]);
    data{chan}=dataDevice.ReadTagV(['ADwb' num2str(chan)],0,maxIndex);
end
