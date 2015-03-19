classdef tdt16bitBlockedDataDevice < tdtDevice
  properties
    nChannels = nan;
    rcxSetup = [];
  end

  methods

    function obj = tdt16bitBlockedDataDevice(deviceInfo, requestedSampleRateHz, channelMap, ~)
      % initialise the class itself
      
      % default value
      rco_leafname = [deviceInfo.name '-nogain-pipebus-and-legacy-16bit-blocked-24.rcx'];
      %rco_leafname = [deviceInfo.name '-nogain-pipebus-and-legacy-16bit.rcx'];
      
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
        %%
        nChannelsPerBlock = 24;
        nBlocks = ceil(obj.nChannels/nChannelsPerBlock);
        nChannelsInSerStore = nChannelsPerBlock/2; % because 16 bit channels are multiplexed in pairs
        
        % the ADidx will increase by nChannelsInSerStore every sample
        nSamplesAvailable = nan(1,nBlocks);
        for block = 1:nBlocks
            nSamplesAvailable(block) = obj.handle.GetTagVal(['ADidx' num2str(block)])/nChannelsInSerStore;
        end
        nSamplesAvailable = floor(min(nSamplesAvailable)/2)*2;
        %fprintf('%d samples available\n', nSamplesAvailable);
        nSamplesToDownload = nSamplesAvailable-offset;
        % good so far
        % data = rand(obj.nChannels, nSamplesToDownload);
        
        % we need (I think) to give GetTagVal the ADidx to read from
        ADidx = offset*nChannelsInSerStore;

        data = nan(obj.nChannels, nSamplesToDownload);
        
        for block = 1:nBlocks
            firstChannelIdx = (block-1)*nChannelsPerBlock+1;
            data(firstChannelIdx:firstChannelIdx+nChannelsPerBlock-1, :) = ...
                obj.handle.ReadTagVEX(['ADwb_mc' num2str(block)], ADidx, nSamplesToDownload, 'I16', 'F64', nChannelsPerBlock)/3276.7;
        end
%         for block = 1:nBlocks
%             maxIndex_32bit(block) = obj.handle.GetTagVal(['ADidx' num2str(block)])/blocksize*2;
%         end
%         maxIndex_32bit = min(maxIndex_32bit);
        
%         blocksize = 32;
%         nBlocks = obj.nChannels/blocksize;
%         
%         if mod(offset_16bit,2)~=0
%             errorBeep('Offset must be a multiple of 2');
%         end
%         
%         maxIndex_32bit = zeros(1,nBlocks);
%         for block = 1:nBlocks
%             maxIndex_32bit(block) = obj.handle.GetTagVal(['ADidx' num2str(block)])/blocksize*2;
%         end
%         maxIndex_32bit = min(maxIndex_32bit);
%         maxIndex_16bit = maxIndex_32bit*2; % we actually have twice as many samples as reported by ADidx
%         
%         DEBUG = true;
%         if true %DEBUG
%             fprintf('Offset %d, available %d\n', offset_16bit, maxIndex_16bit);
%         end
% 
%         nSamples_16bit = maxIndex_16bit-offset_16bit;
%         %offset_32bit = offset_16bit/2;
%         
%         data = nan(obj.nChannels, nSamples_16bit);
%         
%         for block = 1:nBlocks
%             lastIdx = block*blocksize;
%             data(lastIdx-blocksize+1:lastIdx, :) = obj.handle.ReadTagVEX(['ADwb_mc' num2str(block)], offset_16bit, nSamples_16bit, 'I16', 'F64', blocksize)/3276.7;
%         end
%         
%         if DEBUG
%             fprintf('DEBUG: checking downloadAvailableData...');
%             check = obj.downloadAllData;
%             minLen = min(cellfun(@(x) length(x), check));
%             check = cellfun(@(x) x(1:minLen), check, 'uni', false);
%             check = cat(1, check{:});
%             try
%               assert(all(all(data==check(:,offset_16bit+1:offset_16bit+nSamples_16bit))));
%             catch
%                 figure(10);
%                 subplot(2,1,1);
%                 imagesc(check(:,offset_16bit+1:offset_16bit+nSamples_16bit));
%                 subplot(2,1,2);
%                 imagesc(data);
%               keyboard
%             end
%             fprintf('done\n');
%         end
    end
        
    function data = downloadAllData(obj)
        data = downloadAvailableData(obj, 0);
    end

    function data = downloadData(obj, chan, offset_16bit)
        errorBeep('downloadData not implemented yet');
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
      nChannelsPerBlock = 24;
      nBlocks = ceil(nChannels/nChannelsPerBlock);
      nChannelsInSerStore = nChannelsPerBlock/2; % because 16 bit channels are multiplexed in pairs
      
      index = nan(1, nBlocks);
      for block = 1:nBlocks
          index(block) = obj.handle.GetTagVal(['ADidx' num2str(block)])/nChannelsInSerStore;
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
      nChannelsPerBlock = 24;
      block = ceil(chan/nChannelsPerBlock);
      nChannelsInSerStore = nChannelsPerBlock/2; % because 16 bit channels are multiplexed in pairs

      index = obj.handle.GetTagVal(['ADidx' num2str(block)])/nChannelsInSerStore;
    end
    
    function deviceIs16bit = is16Bit(obj)
        deviceIs16bit = true;
    end
    
  end
end
