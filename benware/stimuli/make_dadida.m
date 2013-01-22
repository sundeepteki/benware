function stimvec = make_dadida(sampleRate,Afreq,Aamp,Bfreq,Bamp,tondur,ncycles,prestim)
% Creates prestim and test sequence of A-B-A-pause-A-B-A-pause... as
% vector of values between [-1,1] in stimvec and plays sample
%
% Example: stimvec = stimseq(440,880,200,4,{'A',4,1000});
% 
% INPUTS:   sampleRate: sample rate (Hz)
%           Afreq:      A tone freq (Hz)
%           Aamp:       A tone amplitude (V)
%           Bfreq:      B tone freq (Hz)
%           Bamp:       B tone amplitude (V)
%           tondur:     duration of individual tones (ms)
%           ncycles:    # of A-B-A-pause cycles
% OPTIONAL  prestim:    can specify prestim sequence in the form:
%                       {prestimtone,nprestimcycles,deviantlasttonefreq}                    
%                       prestimtone: either 'A' or 'B'
%                       nprestimcycles: same as ncycles of prestim seq
%                       deviantlasttonefreq: frequency (Hz) of interrupter
%                       deviantlasttoneamp: amplitude(V) of interrupter
%
%                       or simply {} for no prestim
%                       
% Note: assumes that Adur, Bdur, and pause are equal in duration and that 
% prestim seq is made of either A or B tones
% FIXME -- I think all stimuli should be the same length
% FIXME -- Is the interrupter really right?
% FIXME -- Need to set the amplitudes of the tones according to Aamp, Bamp,
% deviantlasttoneamp (i.e. prestim{4})

%sampleRate = 48828.125;

Aseq = ramps(sampleRate,tondur,Afreq);
Bseq = ramps(sampleRate,tondur,Bfreq);

cycle = [Aseq Bseq Aseq zeros(1,length(Aseq))]; % one cycle
testvec = repmat(cycle,1,ncycles);  % repeated ncycle times

prestimparams = length(prestim);

if prestimparams>0  % if prestimulus sequence was specified
    if prestim{1} == 'A'
        prestimcycle = [Aseq zeros(1,length(Aseq)) Aseq zeros(1,length(Aseq))];
    elseif prestim{1} == 'B'
        prestimcycle = [zeros(1,length(Bseq)) Bseq zeros(1,length(Bseq)) zeros(1,length(Bseq))];
    else
        'wtf'
        stimvec = [];
        return
    end
    prestimvec = repmat(prestimcycle,1,prestim{2});
    if ~isempty(prestimparams)   % if there should be a deviant tone
        deviantseq = ramps(sampleRate,tondur,prestim{3});
        prestimvec(end-2*length(deviantseq)+1:end-length(deviantseq)) = deviantseq;
    end
    stimvec = [prestimvec testvec];
else
    L = ncycles * length(Aseq) * 4;
    stimvec = [zeros(1, L) testvec];
end

%tic
%sound(stimvec,sampleRate)
%toc
    

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