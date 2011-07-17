classdef fakeStimDevice < handle
   properties
     deviceName = ''
     sampleRate = -1
     fake = 1
     nSamples = -1;
     WaveformL = zeros(1,2000000);
     WaveformR = zeros(1,2000000);
     StimIndex = 1;
   end
   
   methods
   
      function obj = fakeStimDevice(deviceName, sampleRate)
        obj.deviceName = deviceName;
        obj.sampleRate = sampleRate;
      end
            
      function out = invoke(obj, methodName, varargin)
        out = feval(methodName, obj, varargin{:});
      end
      
      function out = SetTagVal(obj, varName, value)
        setfield(obj, varName, value);
        out = 1;
      end
      
      function out = GetTagVal(obj, varName, value)
        if findstr(varName,'ADidx')
          out = obj.ADidx(eval(varName(6:end)));
        else
          out = getfield(obj, varName);
        end
      end
            
      function out = WriteTagV(obj, varName, offset, value)
        offset = offset + 1;
        var = getfield(obj, varName);
        var(offset:offset+length(value)-1) = value;
        setfield(obj, varName, var);
        out = 1;
      end
      
      function out = WriteTagVEX(obj, varName, offset, type, value)
        offset = offset + 1;
        var = getfield(obj, varName);
        var(offset:offset+length(value)-1) = value;
        setfield(obj, varName, var);
        out = 1;
      end
      
      function out = ReadTagV(obj, varName, offset, len)
        offset = offset + 1;
        var = getfield(obj, varName);
        out = var(offset:offset+len-1);
      end
      
      function out = SoftTrg(obj, n)
        out = 1;
      end

      %function out = ConnectRX6(obj, interface, rack)
      %  obj.deviceType = 'RX6';
      %  out = 1;
      %end

      %function out = ConnectRZ5(obj, interface, rack)
      %  deviceType = 'RZ5';
      %  out = 1;
      %end

      %function out = LoadCOFsf(obj, circuitFilename, sampleRateID)
      %  [dir, filename] = split_path(circuitFilename);
      %  obj.circuitFilename = filename;
      %
      %  obj.sampleRateID = sampleRateID;
      %
      %    switch sampleRateID
      %    case 3
      %      obj.sampleRateHz = 24414.0625;
      % 
      %   case 4
      %     obj.sampleRateHz = 24414.0625*2;
      % 
      %   otherwise
      %     error('Unknown sample rate');
      %  
      %  end
      %
      %  out = 1;
      %end
      
      %function out = Run(obj)
      %  out = 1;
      %end

   end
   %events
   %   EventName
   %end
   %enumeration
   %   EnumName (arg)
   %end
end 