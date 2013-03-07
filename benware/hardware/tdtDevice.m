classdef tdtDevice < handle

  properties
    handle = [];
    deviceName = '';
    rcxFilename = '';
    versionTagName = '';
  end

  methods

    function obj = tdtDevice(deviceName, rcxFilename, versionTagName, versionTagValue, ...
                   requestedSampleRateHz)

       obj.initialise(deviceName, rcxFilename, versionTagName, versionTagValue, ...
                         requestedSampleRateHz);
    end
    
    function initialise(obj, deviceName, rcxFilename, versionTagName, versionTagValue, ...
                    requestedSampleRateHz)
                
      tdt50k = 48828.125;
      sampleRates =   [0.125 0.25 0.5 1 2 4 8]*tdt50k;
      sampleRateIDs = [    0    1   2 3 4 5 6];

      f = find(floor(requestedSampleRateHz)==floor(sampleRates));

      if length(f)==1
        sampleRate = sampleRates(f);
        sampleRateID = sampleRateIDs(f);
      else
        errorBeep('Unknown sample rate');
      end

      if ~isempty(obj.handle)
        [ok, message] = obj.checkDevice(requestedSampleRateHz, versionTagName, versionTagValue);
        
        if ok
          fprintf(['  * ' deviceName ' is already correctly initialised, doing nothing\n']);
          return;
        else
          fprintf(['  * ' deviceName ' needs reinitialisation (' message ')\n']);
        end
        
      end

      fprintf(['  * Initialising ' deviceName '\n']);
      obj.handle = actxcontrol('RPco.x', [5 5 26 26]);

      if invoke(obj.handle, ['Connect' deviceName], 'GB', 1) == 0
        errorBeep(['Cannot connect to ' deviceName ' on GB 1']);
      end
      obj.deviceName = deviceName;

      if invoke(obj.handle, 'LoadCOFsf', rcxFilename, sampleRateID) == 0
        errorBeep(['Cannot upload ' rcxFilename ]);
      end
      obj.rcxFilename = rcxFilename;
      
      if invoke(obj.handle, 'Run') == 0
        errorBeep('Stimulus RCX Circuit failed to run.');
      end
    
      [ok, message] = obj.checkDevice(requestedSampleRateHz, versionTagName, versionTagValue);
      obj.versionTagName = versionTagName;
      
      if ok
        fprintf(['  * ' deviceName ' ready, sample rate = ' num2str(obj.handle.GetSFreq) ' Hz\n']);
      else
        errorBeep(['Couldn''t initialise ' deviceName ': ' message]);
      end
    end
    
    function val = versionTagValue(obj)
        val = obj.handle.GetTagVal(obj.versionTagName);
    end
        
    function [ok, message] = checkDevice(obj, sampleRateHz, ...
                             versionTagName, versionTagValue)
      % [ok, message] = checkDevice(device, sampleRateHz, versionTagName, version)
      % 
      % Check whether a TDT device is in the desired state. If not, return ok=false
      % and provide an explanatory message that a calling function can print to
      % the screen.
      %
      % device: handle to the device
      % sampleRateHz: the sample rate you want
      % versionTagName: the name of a tag in the RCX file that we're using to 
      %   store a circuit version number
      % versionTagValue: the version number expected

      ok = true;
      message = '';
      
      if obj.handle.GetTagVal(versionTagName)~=versionTagValue
        ok = false;
        message = 'wrong circuit loaded';
      elseif obj.sampleRate~=sampleRateHz
        ok = false;
        message = ['wrong sample rate -- requested ' num2str(sampleRateHz) ', got ' num2str(obj.sampleRate)];
      elseif obj.deviceStatus~=7
        ok = false;
        message = ['reports wrong status -- code ' obj.deviceStatus];
      end
    end

    function rate = sampleRate(obj)
        rate = obj.handle.GetSFreq;
    end
    
    function status = deviceStatus(obj)
        status = bitand(obj.handle.GetStatus,7);
    end
    
    
  end

end
