classdef fakeDataDevice < handle
   properties
     deviceName = ''
     sampleRate = -1
     fake = 1
     triggerTime = -1
     timer = []
     MonChan = 1
     ChanMap = zeros(1, 32)
     recdur = 0
     ADidx = zeros(1,32)
   end
   
   methods
   
      function obj = fakeDataDevice(deviceName, sampleRate)
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
      
      function out = SoftTrg(obj, n)
        obj.StimIndex = 0;
        if isobject(obj.timer)
          delete(obj.timer);
          obj.timer = [];
        end
        out = 1;
      end
      
      function out = zBusTrigA(obj)
        obj.triggerTime = now;
        if isobject(obj.timer)
          delete(obj.timer);
          obj.timer = [];
        end
        obj.timer = timer('timerfcn', {@updateFakeDataDevice, obj}, ...
          'ExecutionMode', 'fixedRate', 'BusyMode', 'drop', 'Period', .05);
        start(obj.timer);
        out = 1;
      end
   end
end
