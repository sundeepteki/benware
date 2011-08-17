function bbeep
% produce a beep
% Not using matlab's beep because I usually turn that off.

global state

if isfield(state, 'visualBell') && state.visualBell

  %figure(999);
  %set(999,'menubar','none','toolbar','none');
  %a = subplot(1,1,1);
  %set(a, 'position', [0 0 1 1], 'color', [1 0 0], 'xtick', [], 'ytick', []);
  %makeFigFullscreen;
  %set(gcf, 'position', get(gcf, 'position') + [8 46 -16 -54]);
  set(101, 'color', [1 0 0]);
else

 fs= 44100;

 t = 1/fs:1/fs:0.25;
 f = sin(2*pi*500*t);

 rampLen = floor(5/1000*fs);
 f(1:rampLen) = f(1:rampLen).*(1:rampLen)/rampLen;
 f(end:-1:end-rampLen+1) = f(end:-1:end-rampLen+1).*(1:rampLen)/rampLen;
 sound(f,fs);
end
