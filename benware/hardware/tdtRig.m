classdef tdtRig < handle
  properties
   stimDevice = nan;
   dataDevice = nan;
   zBus = nan;
  end

  methods

    function obj = tdtRig(stimDeviceInfo, dataDeviceInfo)
      obj.stimDevice = tdtStimDevice();
      %obj.dataDevice = tdtDataDevice();
      %obj.zBus = zBus();
    end

  end
end