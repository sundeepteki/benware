function resetDataDevice(dataDevice, trialLen)

if nargin==2
  invoke(dataDevice,'SetTagVal','recdur',trialLen);
end

invoke(dataDevice,'SoftTrg',9);
