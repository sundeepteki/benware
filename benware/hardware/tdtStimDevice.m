classdef tdtStimDevice < tdtDevice
	properties
		nChannels = nan;
		rcxSetups = [];
		% rcxFilenames = {'benware/tdt.monoplay.rcx'; 'benware/tdt.stereoplay.rcx'};
		% versionTags = {{'MonoPlayVer'; 3}; {'StereoPlayVer', 5}};

	end

	methods

		function obj = tdtStimDevice(deviceName, sampleRate, nChannels)
			% initialise the class itself
			obj.rcxSetup(1).rcxFilename = 'benware/tdt/monoplay.rcx';
			obj.rcxSetup(1).versionTagName = 'MonoPlayVer';
			obj.rcxSetup(1).versionTagValue = 3;
			obj.rcxSetup(2).rcxFilename = 'benware/tdt/stereoplay.rcx';
			obj.rcxSetup(2).versionTagName = 'StereoPlayVer';
			obj.rcxSetup(2).versionTagValue = 5;

			obj.channelSetup(1).deviceName = 'RX8';
			obj.channelSetup(1).channelNums = [20 18];
			obj.channelSetup(1).deviceName = 'RX6';
			obj.channelSetup(1).channelNums = [1 2];

			% initialise the device
			obj = obj.initialise(deviceName, sampleRate, nChannels);
		end

		function obj = initialise(deviceName, sampleRate, nChannels)
			rcxSetup = obj.rcxSetup(nChannels);
			obj = obj@tdtDevice(deviceName, rcxSetup.rcxFilename, rcxSetup.versionTagName, ...
								rcxSetup.versionTagValue, sampleRate);

			obj.setChannelNumbers(deviceName);
		end

		function ensureCorrectSettings(deviceName, sampleRate, nChannels)
			rcxSetup = obj.rcxSetup(nChannels);
			obj@tdtDevice.ensureCorrectSettings(deviceName, rcxFilename, versionTagName, versionTagValue, ...
											sampleRate);
			obj.setChannelNumbers(deviceName);
		end

		function setChannelNumbers(deviceName)
			f = find(strcmp({obj.channelSetup(:).name}, deviceName));
			if isempty(f)
				errorBeep('I don''t know the output channel numbers for stim device\n');
			elseif length(f)>1
				errorBeep('Ambiguous stim device name\n');
			end

			obj.handle.SetTagVal('LeftChannel', channelNums(1));
			obj.handle.SetTagVal('RightChannel', channelNums(2));
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