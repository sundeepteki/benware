classdef tdtDevice < handle

  properties
    handle = [];
    deviceName = '';
    rcxFilename = '';
    versionTagName = '';
    versionTagValue = nan;
  end

  methods

    function obj = tdtDevice(deviceName, rcxFilename, versionTagName, versionTagValue, ...
                   requestedSampleRateHz)

      tdt50k = 48828.125;
      sampleRates = [0.5 1 2 4];
      sampleRateIDs = [2 3 4 5];

      f = floor(requestedSampleRateHz)==floor(sampleRates);

      if length(f)==1
        sampleRate = sampleRates(f);
        sampleRateID = sampleRateIDs(f);
      else
        errorBeep('Unknown sample rate');
      end

      if ~isempty(obj.handle)
        [ok, message] = obj.checkDevice(obj.handle, requestedSampleRateHz, versionTagName, versionTagValue);
        
        if ok
          fprintf(['  * ' deviceName ' is already correctly initialised, doing nothing\n']);
          return;
        else
          fprintf(['  * ' deviceName ' needs reinitialisation (' message ')\n']);
        end
        
      end

      obj = obj.initialise(deviceName, rcxFilename, versionTagName, versionTagValue, ...
        requestedSampleRateHz);
    end

    function obj = initialise(deviceName, rcxFilename, versionTagName, versionTagValue, ...
                    requestedSampleRateHz)

      fprintf(['  * Initialising ' deviceName '\n']);
      obj.handle = actxcontrol('RPco.x', [5 5 26 26]);

      if invoke(obj.handle, ['Connect' deviceName], 'GB', 1) == 0
        errorBeep(['Cannot connect to ' deviceName ' on GB 1']);
      end

      if invoke(obj.handle, 'LoadCOFsf', rcxFilename, sampleRate) == 0
        errorBeep(['Cannot upload ' rcxFilename ]);
      end

      if invoke(obj.handle, 'Run') == 0
        errorBeep('Stimulus RCX Circuit failed to run.');
      end

      [ok, message] = checkDevice(obj.handle, sampleRateHz, versionTagName, versionTagValue);

      if ok
        fprintf(['  * ' deviceName ' ready, sample rate = ' num2str(obj.handle.GetSFreq) ' Hz\n']);
      else
        errorBeep(['Couldn''t initialise ' deviceName ': ' message]);
      end
    end

    function [ok, message] = checkDevice(device, sampleRateHz, ...
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

      if device.GetTagVal(versionTagName)~=versionTagValue
        ok = false;
        message = 'wrong circuit loaded';
      elseif device.GetSFreq~=sampleRateHz
        ok = false;
        message = ['wrong sample rate -- ' num2str(device.GetSFreq)];
      elseif bitand(device.GetStatus,7)~=7
        ok = false;
        message = ['reports wrong status -- code ' bitand(device.GetStatus,7)];
      end
    end

  end

end

% function [device, sampleRateHz] = deviceInit(device, deviceName, ...
%   rcxFilename, versionTagName, versionTagValue, requestedSampleRateHz)
% % [device, sampleRateHz] = deviceInit(device, deviceName, ...
% %  rcxFilename, versionTagName, versionTagValue, requestedSampleRateHz)
% % 
% % Initialise a TDT device, set sample rate and rcx circuit, and check
% % that version tag on the circuit is correct
% % 
% % device: Existing handle to the device, or [] if you don't have one
% % deviceName: e.g. 'RZ5'
% % rcxFilename: filename of RCX circuit
% % versionTagName: tag in circuit that contains version number
% % versionTagValue: the expected version number
% % requestedSampleRateHz: desired sample rate

% if requestedSampleRateHz>20000 && requestedSampleRateHz<=25000
%   sampleRate = 2;
%   sampleRateHz = 48828.125/2;
% elseif requestedSampleRateHz>40000 && requestedSampleRateHz<=50000
%   sampleRate = 3;
%   sampleRateHz = 48828.125;
% elseif requestedSampleRateHz>90000 && requestedSampleRateHz<=100000
%   sampleRate = 4;
%   sampleRateHz = 48828.125*2;
% elseif requestedSampleRateHz>180000 && requestedSampleRateHz<=200000
%   sampleRate = 5;
%   sampleRateHz = 48828.125*4;
% else
%   errorBeep('Unknown sample rate');
% end

% % check whether we already have a handle to a correctly set up device
% % if not, clear it

% if ~isempty(device)
  
%   [ok, message] = checkDevice(device, sampleRateHz, versionTagName, versionTagValue);
  
%   if ok
%     fprintf(['  * ' deviceName ' is already initialised, doing nothing\n']);
%     return;
%   else
%     fprintf(['  * ' deviceName ' needs reinitialisation (' message ')\n']);
%   end
  
% end

% fprintf(['  * Initialising ' deviceName '\n']);
% device=actxcontrol('RPco.x', [5 5 26 26]);
% if invoke(device, ['Connect' deviceName], 'GB', 1) == 0
%   errorBeep(['Cannot connect to ' deviceName ' on GB 1']);
% end

% if invoke(device, 'LoadCOFsf', rcxFilename, sampleRate) == 0
%   errorBeep(['Cannot upload ' rcxFilename ]);
% end

% if invoke(device, 'Run') == 0
%   errorBeep('Stimulus RCX Circuit failed to run.');
% end

% [ok, message] = checkDevice(device, sampleRateHz, versionTagName, versionTagValue);

% if ok
%   fprintf(['  * ' deviceName ' ready, sample rate = ' num2str(device.GetSFreq) ' Hz\n']);
% else
%   errorBeep(['Couldn''t initialise ' deviceName ': ' message]);
% end
