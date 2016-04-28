function y=pinkNoiseToken

global noiseTokens;

y=real(ifft(fft(randn(1,2*noiseTokens.iFFTSamples+1)/100).*noiseTokens.iFFTamps)).*noiseTokens.hannWdw;