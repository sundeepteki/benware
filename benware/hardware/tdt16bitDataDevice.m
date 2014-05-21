classdef tdt16bitDataDevice < tdtDevice
  properties
    nChannels = nan;
    rcxSetup = [];
  end

  methods

    function obj = tdt16bitDataDevice(deviceInfo, requestedSampleRateHz, channelMap, ~)
      % initialise the class itself
      
      % default value
      rco_leafname = [deviceInfo.name '-nogain-pipebus-and-legacy-16bit-exptal.rcx'];
      
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
    
    function data = downloadAvailableData(obj, offset_16bit)
        if mod(offset_16bit,2)~=0
            errorBeep('Offset must be a multiple of 2');
        end
        maxIndex_32bit = zeros(1,obj.nChannels);
        for chan = 1:obj.nChannels
            maxIndex_32bit(chan) = obj.handle.GetTagVal(['ADidx' num2str(chan)]);
        end
        maxIndex_32bit = min(maxIndex_32bit);
        maxIndex_16bit = maxIndex_32bit*2; % we actually have twice as many samples as reported by ADidx
        
        DEBUG = false;
        if DEBUG
            fprintf('Offset %d, available %d\n', offset_16bit, maxIndex_16bit);
        end

        nSamples_16bit = maxIndex_16bit-offset_16bit;
        %offset_32bit = offset_16bit/2;
        
        data = nan(obj.nChannels, nSamples_16bit);
        
        for chan = 1:obj.nChannels
            data(chan, :) = obj.handle.ReadTagVEX(['ADwb' num2str(chan)], offset_16bit, nSamples_16bit, 'I16', 'F64', 1);
        end
        
        if DEBUG
            fprintf('DEBUG: checking downloadAvailableData...');
            check = obj.downloadAllData;
            minLen = min(cellfun(@(x) length(x), check));
            check = cellfun(@(x) x(1:minLen), check, 'uni', false);
            check = cat(1, check{:});
            try
              assert(all(all(data==check(:,offset_16bit+1:offset_16bit+nSamples_16bit))));
            catch
                figure(10);
                subplot(2,1,1);
                imagesc(check(:,offset_16bit+1:offset_16bit+nSamples_16bit));
                subplot(2,1,2);
                imagesc(data);
              keyboard
            end
            fprintf('done\n');
        end
    end
        
    function data = downloadAllData(obj)
      % this no longer needs to output a cell array
      data = cell(1, obj.nChannels);
      for chan = 1:obj.nChannels
          maxIndex_32bit = obj.handle.GetTagVal(['ADidx' num2str(chan)]);
          maxIndex_16bit = maxIndex_32bit*2;
          data{chan} = obj.handle.ReadTagVEX(['ADwb' num2str(chan)], 0, maxIndex_16bit, 'I16', 'F64', 1);
      end
    end

    function data = downloadData(obj, chan, offset_16bit)
        if mod(offset_16bit,2)~=0
            errorBeep('Offset must be a multiple of 2');
        end
        maxIndex_32bit = obj.handle.GetTagVal(['ADidx' num2str(chan)]);
        if maxIndex_32bit-offset_32bit==0
            data = [];
        elseif maxIndex_32bit<offset_32bit
            data = [];
            errorBeep('Data requested beyond end of buffer!\n');
        else
            %offset_32bit = offset_16bit/2;
            maxIndex_16bit = maxIndex_32bit*2; % we actually have twice as many samples as reported by ADidx
            nSamples_16bit = maxIndex_16bit-offset_16bit;
            data = obj.handle.ReadTagVEX(['ADwb' num2str(chan)], offset_16bit, nSamples_16bit, 'I16', 'F64', 1);
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
          index(chan) = obj.handle.GetTagVal(['ADidx' num2str(chan)])*2;
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

      index = obj.handle.GetTagVal(['ADidx' num2str(chan)])*2;
    end
    
    function deviceIs16bit = is16Bit(obj)
        deviceIs16bit = true;
    end
    
  end
end
