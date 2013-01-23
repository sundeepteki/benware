function dadida = testseq(Aseq,Agapseq,An,Bseq,Bgap,Bgapseq,Bstart,Bn,Brand,sampleRate,randseed)
% A-B-A-B = one cycle

Aramp = Aseq;
Astartseq = [];

Acycle = repmat([Aramp Agapseq],1,An);

Astream = [Astartseq Acycle];
Bramp = Bseq;

if Bstart>0
    Bstartseq = ramps(sampleRate,Bstart,0);
else
    Bstartseq = [];
end

if Brand == 0
    Bcycle = repmat([Bramp Bgapseq],1,Bn-1);
    if Bn == 0
        Bstream = [Bstartseq Bcycle];
    else
        Bstream = [Bstartseq Bcycle Bramp];
    end
elseif Brand == 1   % random B gap has mean of Bgap
    rand('seed',randseed)
    Brandgaps = exprnd(Bgap,[1 Bn]);
    Brandseq = [];
    for k = 1:length(Brandgaps)
        Bgapseq = ramps(sampleRate,Brandgaps(k),0);
        Bcurrent = [Bgapseq Bramp];
        Brandseq(end+1:end+length(Bcurrent)) = Bcurrent;
    end
    Bstream = [Bstartseq Brandseq];
    if length(Bstream)<Bn*(length(Bseq)+(Bgap/1000*sampleRate))
        Bstream(end+1:round(Bn*(length(Bseq)+(Bgap/1000*sampleRate)))) = 0;
    end
end

% add zeros to make sure Astream and Bstream same length
Astream(end+1:length(Bstream)) = 0;
Bstream(end+1:length(Astream)) = 0;

dadida = Astream+Bstream;


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

if duration < 10    % assumes anything < 10ms is NOT a sound
    stim = zeros(size(uncalib));
else
    stim = uncalib.*env;
end

