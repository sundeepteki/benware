function resetDataDevice(dataDevice, trialLen)

invoke(dataDevice,'SetTagVal','recdur',trialLen);
invoke(dataDevice,'SoftTrg',9);
