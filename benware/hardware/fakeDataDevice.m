classdef fakeDataDevice < handle
  properties
    nChannels = nan;
    sampleRate = nan;
    triggerTime = -1;
    timer = [];
    buffer = [];
    monChan = 1;
    chanMap = [];
    recdur = 0;
    ADidx = [];
    stimDevice = [];
  end

  methods

    function obj = fakeDataDevice(deviceName, requestedSampleRateHz, channelMap, stimDevice)

      obj.nChannels = length(channelMap);
      obj.chanMap = 1:obj.nChannels;
      obj.sampleRate = requestedSampleRateHz;
      obj.ADidx = zeros(1, obj.nChannels);
      obj.stimDevice = stimDevice;
      
    end
    
    function map = channelMap(obj)
      map = 1:obj.nChannels;
    end
    
    function data = downloadAllData(obj)
      maxIndex = min(ADidx);
      data = repmat(obj.buffer(1:maxIndex), nChannels);
    end

    function data = downloadData(obj, chan, offset)
      offset = offset + 1; % matlab indexing from 1
      maxIndex = obj.ADidx(chan);
      if maxIndex-offset==0
        data = [];
      elseif maxIndex<offset
        data = [];
        errorBeep('Data requested beyond end of buffer!\n');
      else
        data = obj.buffer(offset:maxIndex);
      end
    end
    
    function reset(obj, trialLen)
      if nargin==2
        obj.recdur = trialLen;
      end

      % start a sweep
      obj.ADidx = zeros(1, 128);
      if isobject(obj.timer)
        stop(obj.timer);
        delete(obj.timer);
        obj.timer = [];
      end
    end
    
    function setAudioMonitorChannel(obj, chan)
      obj.monChan = chan;
    end
    
    function index = countAllData(obj, nChannels)
      % index = countAllData(dataDevice, nChannels)
      %
      % Count the number of samples available on each channel of the data Device
      % i.e. the index that the serial buffers have reached
      % 
      % dataDevice: A handle to the data device
      % nChannels: The number of channels that you want information about
      % index: 1xnChannels vector of buffer indexes
      index = obj.ADidx;
    end
    
    function index = countData(obj, chan)
      % index = countData(dataDevice, chan)
      %
      % Count number of samples available on a specified channel of the 
      % data device
      %
      % dataDevice: handle of the data device
      % chan: the number of the channel you want
      % index: the index that the serial buffer has reached

      index = obj.ADidx(chan);
    end

    function trigger(obj)
      waveformTmp = obj.stimDevice.intactWaveformL + ...
                    obj.stimDevice.intactWaveformR;
      len=100*ceil(length(waveformTmp)/100);
      waveform = zeros(1,len);
      waveform(1:length(waveformTmp)) = waveformTmp;
      s = std(reshape(waveform,100,len/100));
      origSamplePoints = (1:length(s))/obj.stimDevice.sampleRate*100;
      maxSamples = floor(obj.recdur/1000*obj.sampleRate)+1;
      newSamplePoints = (1:maxSamples)/obj.sampleRate;
      s = interp1(origSamplePoints,s,newSamplePoints);
      responseProbability = s/max(s)/obj.sampleRate*100; % originally * 20
      responseProbability(isnan(responseProbability)) = 0;
      r = rand(1, maxSamples);
      s(~isfinite(s)) = 0;
      obj.buffer = single((0.1*s/max(s)+0.1*r - (r<responseProbability)) *.002);
      obj.ADidx = zeros(1,obj.nChannels);
      obj.triggerTime = now;
      if isobject(obj.timer)
        delete(obj.timer);
        obj.timer = [];
      end
      obj.timer = timer('timerfcn', {@updateFakeDataDevice, obj}, ...
        'ExecutionMode', 'fixedRate', 'BusyMode', 'drop', 'Period', .05);
      start(obj.timer);
    end
    
  end
end
