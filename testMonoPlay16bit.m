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

success = invoke(handle, 'LoadCOFsf', '.\benware\tdt\RX6-stereoplay16bit.rcx', 3);
if ~success
    fprintf('upload failed\n');
end

invoke(handle,'Run');

z = actxcontrol('ZBUS.x',[1 1 1 1]);

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
