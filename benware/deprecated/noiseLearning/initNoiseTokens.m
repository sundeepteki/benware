function initNoiseTokens(numTokens, ranSeed, tokenDuration, isi, AseqLen, BseqLen);
%  makes a global structure noiseTokens that holds noise tokens for noise
%  learning / adaptation experiment.
%     inputs: 
%  numTokens: number of tokens to make
%  ranSeed: random number seed, must be >= 0 integer
%  tokenDuration : length of noise tokens in ms
%  isi : inter stim interval (ms)
%  AseqLen, BseqLen: number of noise tokens in uniform "A" series and
%     non-uniform "B" series respectively
%
%  Example: make 20 noise tokens to 100 ms duration with random seed 1:
%
%  initNoiseTokens(20, 1, 100, 200, 40, 100);
%  svect=makeAnoiseSequence;  % make uniform sound sequence
%  global noiseTokens
%  sound(svect,noiseTokens.fs);  % play
%  svect=makeBnoiseSequence(6);  % pick noise 6 as special & make nonuniform sound sequence
%  sound(svect,noiseTokens.fs);  % play
%     
%%
global noiseTokens;

noiseTokens.fs=97656.25;
noiseTokens.iFFTSamples=round(noiseTokens.fs*tokenDuration/1000/2);
noiseTokens.hannWdw=hanning(2*noiseTokens.iFFTSamples+1)';
noiseTokens.isi=isi;
noiseTokens.AseqLen=AseqLen;
noiseTokens.BseqLen=BseqLen;

% work out 1/f amplitude spectrum
iFFTamps=1./((1:noiseTokens.iFFTSamples)/noiseTokens.iFFTSamples);
% apply high-cut at 30 K
HighCutBin=round(30000*2/noiseTokens.fs*iFFTamps);
iFFTamps(HighCutBin:end)=0;
% apply low cut at 500 Hz
LowCutBin=round(500*2/noiseTokens.fs*iFFTamps);
iFFTamps(1:LowCutBin)=0;
% fold to make an FFT format amplitude spectrum
noiseTokens.iFFTamps=[0 iFFTamps fliplr(iFFTamps)];
% now initialize random number generator, then loop to make
% numTokens different noise tokens. 
% The algorithm is to take fft of white gaussian noise tokens and
% change their amplitude spectra to bandpass pink, then invert the fft.
noiseTokens.randomStream=RandStream('mt19937ar','Seed',ranSeed);
noiseTokens.freshNoiseStream=RandStream('mt19937ar','Seed',ranSeed+10);
RandStream.setDefaultStream(noiseTokens.randomStream);
reset(noiseTokens.randomStream);
noiseTokens.noise={};
for ii=1:numTokens;
    noiseTokens.screeningNoise{ii}=pinkNoiseToken;
    noiseTokens.noise{ii}=pinkNoiseToken;
end;
% make Uniform Sequence
initUniformSequence(AseqLen);
% make B sequence
reset(noiseTokens.randomStream);
s=[ones(1,noiseTokens.BseqLen) zeros(1,noiseTokens.BseqLen)];
noiseTokens.specialSequence=s(randperm(length(s)));



