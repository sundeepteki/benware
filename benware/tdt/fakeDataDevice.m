classdef fakeDataDevice < handle
   properties
     deviceName = ''
     sampleRate = -1
     fake = 1
     triggerTime = -1
     timer = []
     stimDevice = []
     buffer = [];
     MonChan = 1
     ChanMap = zeros(1, 128)
     recdur = 0
     ADidx = zeros(1, 128)
   end
   
   methods
   
      function obj = fakeDataDevice(deviceName, sampleRate, stimDevice)
        obj.deviceName = deviceName;
        obj.sampleRate = sampleRate;
        obj.stimDevice = stimDevice;
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
        offset = offset+1;
        out = obj.buffer(offset:offset+len-1);
        %r = rand(1,len);
        %out = r*.0001 - (r>.999)*.001;
      end
      
      function out = SoftTrg(obj, n)
        obj.ADidx = zeros(1, 128);
        if isobject(obj.timer)
          stop(obj.timer);
          delete(obj.timer);
          obj.timer = [];
        end
        out = 1;
      end
      
      function out = zBusTrigA(obj)
        waveformTmp = obj.stimDevice.intactWaveformL + ...
          obj.stimDevice.intactWaveformR;
        len=100*ceil(length(waveformTmp)/100);
        waveform = zeros(1,len);
        waveform(1:length(waveformTmp)) = waveformTmp;
        s = std(reshape(waveform,100,len/100));
        origSamplePoints = (1:length(s))/obj.stimDevice.sampleRate*100;
        maxSamples = floor(obj.recdur/1000*obj.sampleRate)+1;
        newSamplePoints = (1:maxSamples)/obj.sampleRate;
        s = interp1(origSamplePoints,s,newSamplePoints);
        responseProbability = s/max(s)/obj.sampleRate*100; % originally * 20
        responseProbability(isnan(responseProbability)) = 0;
        r = rand(1, maxSamples);
        obj.buffer = single((0.1*r - (r<responseProbability)) *.002);

        obj.ADidx = zeros(1,128);
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
