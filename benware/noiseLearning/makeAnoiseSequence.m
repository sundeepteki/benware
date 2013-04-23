function makeAnoiseSequence(id)
global noiseTokens;

noiseTokens.noise{1} = noiseTokens.screeningNoise{id};
noiseTokens.AStimulus=noiseTokenSequence(noiseTokens.isi,noiseTokens.uniformSequence, noiseTokens.fs, noiseTokens.noise);