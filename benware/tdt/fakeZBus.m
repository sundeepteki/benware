classdef fakeZBus
   properties
      stimDevice
      dataDevice
      fake
   end
   methods
      function obj = fakeZBus(stimDev, dataDev)
        obj.stimDevice = stimDev;
        obj.dataDevice = dataDev;
        obj.fake = true;
      end
      
      function out = invoke(obj, methodName, varargin)
        out = feval(methodName, obj, varargin{:});
      end

      function out = ConnectZBus(obj, interface)
        out = 1;
      end

      function out = HardwareReset(obj, interface)
        out = 1;
      end

      function out = zBusTrigA(obj, a, b, c)
        if ~isempty(obj.stimDevice)
          obj.stimDevice.zBusTrigA();
        end          
        if ~isempty(obj.dataDevice)
          obj.dataDevice.zBusTrigA();
        end
        out = 1;
      end
   end
end 