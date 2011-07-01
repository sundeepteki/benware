function data = downloadData(dataDevice, chan, offset)

maxIndex=dataDevice.GetTagVal(['ADidx' num2str(chan)]);
if maxIndex-offset==0
  data = [];
elseif maxIndex<offset
  data = [];
  errorBeep('Data requested beyond end of buffer!\n');
else
  data=dataDevice.ReadTagV(['ADwb' num2str(chan)],offset,maxIndex-offset);
end
