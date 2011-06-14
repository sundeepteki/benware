fs_in = 25000;

f = fopen('f:\fakedata\raw.f32\P04.noise.sweep.2.channel.18.f32');
data{1} = fread(f,inf,'float32');
fclose(f);

d = repmat(data{1},30/50*100,1);
plot(d);
%f = createSpikeBandpassFilter;

%
  dt = 0.040959999071638; % ms
  fs = 1000/dt; 
  Wp = [300 3000];
  n = 2;
  [B,A] = ellip(n, 0.01, 40, Wp/(fs/2));

%sig = rand(1,fs_in*30);

%
tic;
profile on;
df = filtfilt(B,A,d);
threshold = -4;
s = df / std(df(:)) + threshold;
zc = find(diff(sign(s))<0);
toc
profile report
plot(s);
length(zc)

%toc
%size(sig,1)/fs_in
%profile report