classdef tdtStimDevice < tdtDevice
  properties
  end

  methods

    function obj = tdtStimDevice(deviceName, requestedSampleRateHz, nChannels)

      if nChannels==1
          rcxFilename = '../tdt/monoplay.rcx';
          versionTagName = 'MonoPlayVer';
          versionTagValue = 3;
      elseif nChannels==2
          rcxFilename = '../tdt/stereoplay.rcx';
          versionTagName = 'StereoPlayVer';
          versionTagValue = 5;
      else
          errorBeep('Can only do mono or stereo\n');
      end
      
      obj = obj@tdtDevice(deviceName, rcxFilename, versionTagName, versionTagValue, ...
                   requestedSampleRateHz);

      if strcmp(deviceName, 'RX8')
          channel.L = 20;
          channel.R = 18;

      elseif strcmp(deviceName, 'RX6')
          channel.L = 1;
          channel.R = 2;
      
      else
          errorBeep('I don''t know the output channel numbers for this device\n');
      end

      obj.handle.SetTagVal('LeftChannel', channel.L);
      obj.handle.SetTagVal('RightChannel', channel.R);

    end

  end
end