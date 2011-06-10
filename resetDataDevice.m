function resetDataDevice(trialLen)

global dataDevice

invoke(dataDevice,'SetTagVal','recdur',trialLen);
invoke(dataDevice,'SoftTrg',9);
