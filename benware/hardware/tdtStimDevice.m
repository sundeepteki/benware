classdef tdtStimDevice < tdtDevice
	properties
	end

	methods

		function obj = tdtStimDevice(deviceName, requestedSampleRateHz, nChannels)

			if nChannels==1
				rcxFilename = 'benware/tdt/monoplay.rcx';
				versionTagName = 'MonoPlayVer';
				versionTagValue = 3;
			elseif nChannels==2
				rcxFilename = 'benware/tdt/stereoplay.rcx';
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

		function stim = downloadStim(obj, offset, nSamples, nStimChans)
	    % why is nStimChans specified here? It should be obvious 
	    % from the stimDevice. i think that however channel numbers
	    % are specified should be rationalised
	    stim(1,:) = obj.handle.ReadTagV('WaveformL', offset, nSamples);
	        
	    if nStimChans==2
	    	stim(2,:) = obj.handle.ReadTagV('WaveformR', offset, nSamples);
	    end
	  end

	  function index = getStimIndex(obj)
	  	index = obj.handle.GetTagVal('StimIndex');
	  end
	  
	  function nSamples = getStimLength(obj)
	  	nSamples = obj.handle.GetTagVal('nSamples');
	  end
	  
	  function reset(obj)
	  	obj.handle.SoftTrg(9);
	  end
	  
	  function setActiveStimChannels(obj, nChannels)
	  	obj.handle.SetTagVal('LeftActive', 1);

	  	if nChannels==1
	  		obj.handle.SetTagVal('RightActive', 0);
	  	else
	  		obj.handle.SetTagVal('RightActive', 1);    
	  	end
	  end
	  
	  function setStimLength(obj, samples)
	  	if ~obj.handle.SetTagVal('nSamples', samples)
	  		errorBeep('WriteTag nSamples failed');
	  	end
	  end
	  
	  function softTriggerStimulus(stimDevice)
	  	invoke(stimDevice,'SoftTrg',1);
	  end
	  
	  function uploadStim(obj, stim, offset)
	    % Note it's also necessary to set nSamples for the new stimulus

	    %[offset offset+size(stim,2) getStimIndex]
	    %if ~stimDevice.WriteTagV('WaveformL',offset,stim(1,:))
	    %    errorBeep('WriteTagV WaveformL failed');
	    %end
	    %if ~stimDevice.WriteTagV('WaveformR',offset,stim(2,:))
	    %    errorBeep('WriteTagV WaveformR failed');
	    %end;

	    maxRetries = 2;

	    nRetries = 0;
	    success = false;

	    while ~success && nRetries<maxRetries
	    	success = obj.handle.WriteTagV('WaveformL',offset,stim(1,:));
	    	if ~success
	    		fprintf('== WriteTagV WaveformL failed\n');
	    		nRetries = nRetries + 1;
	    	end
	    end

	    if ~success
	    	errorBeep('Giving up after 3 attempts!');
	    end

	    if size(stim,1)==1
	    	return
	    end

	    nRetries = 0;
	    success = false;

	    while ~success && nRetries<maxRetries
	    	success = obj.handle.WriteTagV('WaveformR',offset,stim(2,:));
	    	if ~success
	    		fprintf('== WriteTagV WaveformR failed\n');
	    		nRetries = nRetries + 1;
	    	end
	    end

	    if ~success
	    	errorBeep('Giving up after 3 attempts!');
	    end
	  end

	  function uploadWholeStim(obj, stim)
	    % uploadWholeStimulus(obj, stim)
	    %
	    % Upload a stereo stimulus to stimDevice, and inform the device
	    % about the stimulus length

	    if ~obj.handle.SetTagVal('nSamples',size(stim,2))
	    	errorBeep('WriteTag nSamples failed');
	    end

	    if ~obj.handle.WriteTagV('WaveformL',0,stim(1,:))
	    	errorBeep('WriteTagV WaveformL failed');
	    end

	    if size(stim, 1)==1
	    	return
	    end

	    if ~obj.handle.WriteTagV('WaveformR',0,stim(2,:))
	    	errorBeep('WriteTagV WaveformR failed');
	    end
	  end
      
  end
end