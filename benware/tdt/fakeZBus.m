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

      function out = ZBusTrigA(obj, a, b, c)
        if ~isempty(obj.stimDevice)
          obj.stimDevice.fakeZBusTrigger()
        end          
        if ~isempty(obj.dataDevice)
          obj.dataDevice.fakeZBusTrigger()
        end
        out = 1;
      end
      
      %function out = isFake
      %  out = true;
      %end
      %function error = ConnectZBus(interface)
      %  error = 1;
      %end
   end
   %events
   %   EventName
   %end
   %enumeration
   %   EnumName (arg)
   %end
end 