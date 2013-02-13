function [Aseq Agapseq Bseq Bgapseq prestimvec] = prestimseq(Afreq,Bfreq,Alev,Blev,Agap,Bgap,tondur,intdur,nprecycles,prestim,sampleRate)
% prestim:
%   0: silence (prestim = 0)
%   1: A       (prestim = [1 fdev levdev])
%              if f and lev same as Afreq and Alev, then normal A A A priming    

intt = 0:1/sampleRate:intdur/1000;
intseq = zeros(1,length(intt));
if intdur == 0
    intseq = [];
end

Aramp = ramps(sampleRate,tondur,Afreq).*Alev;
if Agap == 0
    Agapseq = [];
else
    Agapseq = ramps(sampleRate,Agap,0);
end
Aseq = [Aramp intseq];

Bramp = ramps(sampleRate,tondur,Bfreq).*Blev;
if Bgap == 0
    Bgapseq = [];
else
    Bgapseq = ramps(sampleRate,Bgap,0);
end
Bseq = [Bramp intseq];

if prestim(1) == 0
    silentcycle = zeros(1,2*(length(Aseq)+length(Agapseq)));
    prestimvec = repmat(silentcycle,1,nprecycles);
elseif prestim(1) == 1  % prestim = [1,f,lev] where f and lev for LAST TONE only, otherwise priming seq assumed to be A tones
    prestimseq = [Aseq Agapseq Aseq Agapseq];
    prestimvec = repmat(prestimseq,1,nprecycles);
    deviantramp = ramps(sampleRate,tondur,prestim(2)).*prestim(3);
    deviantseq = [deviantramp intseq];
    try
        prestimvec(end-length(deviantseq)-length(Agapseq)+1:end-length(Agapseq)) = deviantseq;
    catch
        keyboard
    end
else
    keyboard
end
    

function stim = ramps(sampleRate,duration,freq)
% code from Ben Willmore

% time
t = 0:1/sampleRate:duration/1000;

% sinusoid
uncalib = sin(2*pi*freq*t);

% ramp up and down
ramplen_samples = round(5/1000*sampleRate);
ramp = (1-cos(pi*(1:ramplen_samples)/ramplen_samples))/2;
env = [ramp ones(1,length(uncalib)-2*length(ramp)) fliplr(ramp)];
stim = uncalib.*env;