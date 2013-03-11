classdef stimAndDataTrigger < handle

	properties
	  stimDevice = [];
	  dataDevice = [];
	end

	methods
	  function obj = stimAndDataTrigger(stimDevice, dataDevice)
	  	obj.stimDevice = stimDevice;
	  	obj.dataDevice = dataDevice;
	  end

	  function trigger(obj)
	  	obj.stimDevice.trigger();
	  	obj.dataDevice.trigger();
	  end

	end
end