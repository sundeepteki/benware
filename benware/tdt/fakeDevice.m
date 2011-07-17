classdef fakeDevice < handle
   properties
     deviceType
     circuitFilename
     sampleRateID
     sampleRateHz
     fake = 1
   end
   
   methods

      %function obj = fakeDevice
      %  obj.fake = true
      %end
      
      function out = invoke(obj, methodName, varargin)
        out = feval(methodName, obj, varargin{:});
      end

      function out = ConnectRX6(obj, interface, rack)
        obj.deviceType = 'RX6';
        out = 1;
      end

      function out = ConnectRZ5(obj, interface, rack)
        deviceType = 'RZ5';
        out = 1;
      end

      function out = LoadCOFsf(obj, circuitFilename, sampleRateID)
        [dir, filename] = split_path(circuitFilename);
        obj.circuitFilename = filename;

        obj.sampleRateID = sampleRateID;

        switch sampleRateID
          case 3
            obj.sampleRateHz = 24414.0625;
        
          case 4
            obj.sampleRateHz = 24414.0625*2;
        
          otherwise
            error('Unknown sample rate');
        
        end

        out = 1;
      end
      
      function out = Run(obj)
        out = 1;
      end

   end
   %events
   %   EventName
   %end
   %enumeration
   %   EnumName (arg)
   %end
end 