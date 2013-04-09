% test motu
f1 = 5000;
f2 = 5100;
dur = 50;

fs = 44100; % 0.08667; 0.088
t = (1:fs*dur)/fs;

f = sin(2*pi*2*t);
f = f-min(f);
f = f/max(f);
f = f*(f2-f1)/2+f1;

depth1 = 0.3;
fm1 = 1;
depth2 = 0.1;
fm2 = 1.33;
s = cos(2*pi*f1*t + depth1*f1/fm1*sin(2*pi*fm1*t) + depth2*f1/fm2*sin(2*pi*fm2*t));

ramp = 1:round(5/1000*fs);
ramp = ramp/max(ramp);
env = [ramp ones(1,length(s)-2*length(ramp)) fliplr(ramp)];
s = s.*env;
s = [s;s]/100;


%%
tic
dev = playRecStimDevice('MOTU Audio ASIO',fs, 2);
toc

%%
dev.triggerPlayRec(s);
rec=dev.waitAndGetRec;
toc
figure(1);
plot(s(1,:));
hold all;
plot(rec(:,3));
hold off;

figure(2);
subplot(2,1,1);
specgram(s(1,:)',[],fs);
subplot(2,1,2);
specgram(rec(:,3),[],fs);
