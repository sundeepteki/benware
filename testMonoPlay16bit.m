% testmonoplay16bit
tdt50k = 48828.125;
dur = 5;

fs = tdt50k;

f1 = 1000;
f2 = 5100;

t = (1:fs*dur)/fs;

depth1 = 0.3;
fm1 = 1;
depth2 = 0.1;
fm2 = 1000;
s = cos(2*pi*f1*t + depth1*f1/fm1*sin(2*pi*fm1*t) + depth2*f1/fm2*sin(2*pi*fm2*t));

%%

handle = actxcontrol('RPco.x', [5 5 26 26]);

success = invoke(handle, 'ConnectRX6', 'GB', 1);
if ~success
    fprintf('no device\n');
end

success = invoke(handle, 'LoadCOFsf', '.\benware\tdt\RX6-stereoplay16bit.rcx', 5);
if ~success
    fprintf('upload failed\n');
end

invoke(handle,'Run');

z = actxcontrol('ZBUS.x',[1 1 1 1]);

%
s = [1 2 3 4 5 6 7 8]*10000;
s = int16(s);
s = typecast(s, 'double');

tic
success = handle.WriteTagV('WaveformL', 0, 1:1953125)
toc
tic
success = handle.WriteTagVEX('WaveformL', 0, 'i16', int16(1:1953125))
toc
data = handle.ReadTagVEX('WaveformL', 0, 16, 'i16', 'f64', 1)
data = handle.ReadTagVEX('WaveformL', 1953100, 16, 'i16', 'f64', 1)

%% convert to interleaved 16 bit format
mx = max(abs(s));
sc = int16(s/mx*(2^15-1));
scc = int32(sc(1:2:end))*2^16 + int32(sc(2:2:end));

%
success = handle.WriteTagVEX('WaveformL',0,'I32',scc);
%       success = handle.WriteTagV('WaveformL', 0, scc)
success = handle.SetTagVal('nSamples', length(s)*2)

success = handle.SoftTrg(9)
z.zBusTrigA(0,0,5)

%%

stim = s;
scaleFactor = max(abs(stim(:)));
stim_16bit = int16(s/scaleFactor*(2^15-1));
encodedStim = int32(stim_16bit(1:2:end))*2^16 + int32(stim_16bit(2:2:end));
            scaleFactor = 1/scaleFactor;
  