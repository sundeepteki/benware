function makeBnoiseSequence
global noiseTokens;


% start off with a period of silence
sampsPerInterval=noiseTokens.isi/1000*noiseTokens.fs;
svect=zeros(1,ceil(sampsPerInterval*(noiseTokens.BseqLen+1)));
% now populate
tokenLen=length(noiseTokens.noise{1});
RandStream.setDefaultStream(noiseTokens.freshNoiseStream);
reset(noiseTokens.freshNoiseStream);
for ii=1:noiseTokens.BseqLen,
    noiseStart=ceil((ii-1)*sampsPerInterval)+1;
    noiseEnd=noiseStart+tokenLen-1;
    if noiseTokens.specialSequence(ii),
        % add "special" frozenNoise
        svect(noiseStart:noiseEnd)=noiseTokens.noise{1};
    else
        % add fresh random noise
        svect(noiseStart:noiseEnd)=pinkNoiseToken;
    end;
end;

noiseTokens.BStimulus = svect;
