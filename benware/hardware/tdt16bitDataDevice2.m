classdef tdt16bitDataDevice2 < tdtDevice
  properties
    nChannels = nan;
    rcxSetup = [];
  end

  methods

    function obj = tdtDataDevice(deviceInfo, requestedSampleRateHz, channelMap, ~)
      % initialise the class itself
      
      % default value
      rco_leafname = [deviceInfo.name '-nogain-pipebus-and-legacy-16bit.rcx'];
      
      obj.rcxSetup.rcxFilename = ['benware/tdt/' rco_leafname];
      obj.rcxSetup.versionTagName = [deviceInfo.name 'NoGainVer'];
      obj.rcxSetup.versionTagValue = 3;

      % initialise the device
      obj.initialise(deviceInfo, requestedSampleRateHz, channelMap);
    end
    
    function initialise(obj, deviceInfo, requestedSampleRateHz, channelMap)
      obj.initialise@tdtDevice(deviceInfo, obj.rcxSetup.rcxFilename, requestedSampleRateHz);
      obj.setChannelMap(channelMap);
      obj.nChannels = length(channelMap);
      if ~obj.checkDevice(deviceInfo, requestedSampleRateHz, channelMap);
        errorBeep('DataDevice is not in requested state after initialisation');
      end
    end

    function [ok, message] = checkDevice(obj, deviceInfo, sampleRate, channelMap)
        % call this to make sure the TDT is in the desired state
        [ok, message] = obj.checkDevice@tdtDevice(deviceInfo, sampleRate, ...
            obj.rcxSetup.versionTagName, obj.rcxSetup.versionTagValue);
        obj.setChannelMap(channelMap);
        obj.reset;
    end

    function map = channelMap(obj)
      map = obj.handle.ReadTagVEX('ChanMap', 0, obj.nChannels ,'I32', 'F64', 1);
    end

    function setChannelMap(obj, channelMap)
       obj.handle.WriteTagVEX('ChanMap',0,'I32',channelMap);
       obj.nChannels = length(channelMap);
    end
    
    function data = downloadAvailableData(obj, offset)
        maxIndex = zeros(1,obj.nChannels);
        for chan = 1:obj.nChannels
            maxIndex(chan) = obj.handle.GetTagVal(['ADidx' num2str(chan)]);
        end
        maxIndex = min(maxIndex);

        nSamples = maxIndex-offset;
        data = nan(obj.nChannels, nSamples);

        for chan = 1:obj.nChannels
            data(chan, :) = obj.handle.ReadTagVEX(['ADwb' num2str(chan)], offset, nSamples, 'I16', 'F64');
        end
    end
        
    function data = downloadAllData(obj)
      % this no longer needs to output a cell array
      data = cell(1, obj.nChannels);
      for chan = 1:obj.nChannels
          maxIndex = obj.handle.GetTagVal(['ADidx' num2str(chan)]);
          data{chan} = obj.handle.ReadTagVEX(['ADwb' num2str(chan)],0,maxIndex, 'I16', 'F64');
      end
    end

    function data = downloadData(obj, chan, offset)
      maxIndex = obj.handle.GetTagVal(['ADidx' num2str(chan)]);
      if maxIndex-offset==0
        data = [];
      elseif maxIndex<offset
        data = [];
        errorBeep('Data requested beyond end of buffer!\n');
      else
        data = obj.handle.ReadTagVEX(['ADwb' num2str(chan)],offset,maxIndex-offset, 'I16', 'F64');
      end
    end
    
    function reset(obj, trialLen)
      if nargin==2
        obj.handle.SetTagVal('recdur',trialLen);
      end
      obj.handle.SoftTrg(9);
    end
    
    function setAudioMonitorChannel(obj, chan)
      obj.handle.SetTagVal('MonChan',chan);
    end
    
    function softTrigger(obj)
      obj.handle.SoftTrg(1);
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

      index = nan(1, nChannels);
      for chan = 1:nChannels
          index(chan) = obj.handle.GetTagVal(['ADidx' num2str(chan)]);
      end
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

      index = obj.handle.GetTagVal(['ADidx' num2str(chan)]);
    end
    
  end
end
