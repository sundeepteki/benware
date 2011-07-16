function bbeep
% produce a beep
% Not using matlab's beep because I usually turn that off.

fs= 44100;

t = 1/fs:1/fs:0.25;
f = sin(2*pi*500*t);

rampLen = floor(5/1000*fs);
f(1:rampLen) = f(1:rampLen).*(1:rampLen)/rampLen;
f(end:-1:end-rampLen+1) = f(end:-1:end-rampLen+1).*(1:rampLen)/rampLen;
sound(f,fs);
