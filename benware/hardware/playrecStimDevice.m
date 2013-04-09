classdef playrecStimDevice < handle
  properties
      deviceName = '';
      nChannels = nan;
      totalChannels = nan;
      sampleRate = nan;
      currentPage = nan;
  end

  methods

    function obj = playrecStimDevice(deviceName, requestedSampleRateHz, nChannels)
       obj.initialise(deviceName, requestedSampleRateHz, nChannels);
    end
    
    
    function initialise(obj, deviceName, f_s, nChannels)
        obj.deviceName = deviceName;
        obj.nChannels = nChannels;
        obj.totalChannels = nChannels + 1; % need an extra channel for trigger
        obj.sampleRate = f_s;
        
        devs = playrec('getDevices');
        f = strcmp({devs(:).name}, deviceName);
        
        if isempty(f)
            errorBeep(sprintf('%s is not available', deviceName));
        elseif length(f)>1
            errorBeep(sprintf('Device name -- %s -- is ambiguous', deviceName));
        end
            
        deviceID = devs().deviceID;
        
        if ~any([44100 48000 88200 96000]==f_s)
            errorBeep('Unsupported sample rate');
        end
        
        if playrec('isInitialised')
            
            if playrec('getSampleRate')==f_s
                fprintf('  * %s is already initialised at correct sample rate\n', deviceName);
                
                [page, sample] = playrec('getCurrentPosition');
                if page~=-1 || sample~=-1
                    fprintf('  * Stopping current output\n');
                    playrec('delPage'); % stop any pending output
                end
                return;
                
            else
                fprintf('  * %s is already initialised at wrong sample rate; resetting...', deviceName);
                playrec('reset');
                fprintf('done.\n');
            end
            
        end

        % three goes seem to be enough to convince the thing to init
        % properly
        fprintf('  * Initialising %s', deviceName);
        playrec('init', f_s, deviceID, deviceID, obj.totalChannels, 5, 0);
        fprintf('.');
        playrec('reset');
        fprintf('.');
        playrec('init', f_s, deviceID, deviceID, obj.totalChannels, 5, 0);
        fprintf('.');
        playrec('reset');
        fprintf('.');
        playrec('init', f_s, deviceID, deviceID, obj.totalChannels, 5, 0);
        
        % play a second of silence to clear out any junk
        playrec('play', zeros(f_s, obj.totalChannels), 1:obj.totalChannels);

        if ~playrec('isInitialised');
            errorBeep('initialisation failed');
            return;

        else
            fprintf('\n  * %s ready, sample rate = %d Hz\n', obj.deviceName, obj.sampleRate);
            return;
        end
        
        
    end
    
    function triggerPlayRec(obj, snd)
        assert(size(snd,1)==obj.totalChannels-1);
        snd(end+1,:) = 0;
        snd(end, 1) = 1;
        playrec('pause', 1);
        obj.currentPage = playrec('playrec', snd', 1:obj.totalChannels, -1, 1:5);
        playrec('pause', 0);
    end
    
    function rec = waitAndGetRec(obj)
        fprintf('Waiting');
        while ~playrec('isFinished', obj.currentPage)
            fprintf('.');
            pause(0.5);
        end
        fprintf('\n');
        rec = playrec('getRec', obj.currentPage);
        obj.currentPage = nan;
    end
  end
end