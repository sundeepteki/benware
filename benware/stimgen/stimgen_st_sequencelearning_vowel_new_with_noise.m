function stim = stimgen_st_sequencelearning_vowel_new_with_noise(expt, grid, varargin)

%{

Function to make vowel sequences for sequence learning experiment D: 
add noise within vowel sequence

Sundeep Teki
v1: 26-Jun-2016 12:56:56

%}


%% get parameters

sampleRate  = grid.sampleRate; 
nChannels   = expt.nStimChannels;
vowel       = grid.vowel;
vowel_freqs = cell2mat(varargin);
assert(length(vowel_freqs)==4);

%% make vowel vector

t           = 0:1/(sampleRate-1):vowel.dur;
nsamples    = length(t);

% Convert to parallel complex one-poles (PFE):
[r,p,f]     = residuez(B,A);
As          = zeros(nsecs,3);
Bs          = zeros(nsecs,3);

% complex-conjugate pairs are adjacent in r and p:
for i=1:2:2*nsecs
    k       = 1+(i-1)/2;
    Bs(k,:) = [r(i)+r(i+1),  -(r(i)*p(i+1)+r(i+1)*p(i)), 0];
    As(k,:) = [1, -(p(i)+p(i+1)), p(i)*p(i+1)];
end


% Now synthesize the vowel
seq_vowel1   = [];
seq_noise    = [];
seq_vowel34  = [];
seq_vowel    = [];

for i = 1:length(vowel.freqs)
        
    % creating formant filters with bandwiths
    nsecs       = length(vowel.formants);
    R           = exp(-pi*vowel.bandwidth/sampleRate);   % Pole radii (see Pole-zero plot)
    theta       = 2*pi*vowel.formants_all(i,:)/sampleRate;         % Pole angles
    poles       = R .* exp(j*theta);        % Complex poles
    B           = 1;
    A           = real(poly([poles,conj(poles)]));

    vowel_f0 = vowel_freqs(i);      % added by ST
    waveform = [];
    
    w0T   = 2*pi*vowel_f0/sampleRate;                 % radians per sample     
    nharm = floor((sampleRate/2)/vowel_f0);         % number of harmonics
    sig   = zeros(1,nsamples);
    n     = 0:(nsamples-1);
    
    if strcmp(vowel.carrier,'clicktrain')
        % use click train as carrier
        sig      = zeros(1,nsamples);
        interval = round(sampleRate/vowel_f0);% * 0.5 cause this is going to have positive and negative impulses
        sig(1:interval:nsamples) = 1;
        sig(2:interval:nsamples) = -1;
    else
        
        % use bandlimited impulse train as carrier
        for i=1:nharm,
            sig = sig + cos(i*w0T*n);
        end;
        sig = sig/max(sig);
    end
    
    % create sound vector
    waveform = filter(1,A,sig);
    waveform = vowel.amp/sqrt(mean(waveform.^2)) .* waveform; % set the amplitude using the rms of the waveform
    
    window = hanning(ceil(sampleRate*2*vowel.hannramp),'periodic');   % ST edit
    window = [window(1:ceil(sampleRate*vowel.hannramp)) ; ones(nsamples-ceil(sampleRate*vowel.hannramp)-floor(sampleRate*vowel.hannramp)-1,1) ; window(floor(sampleRate*vowel.hannramp)+1:end)]; % build hanning window for stimulus
    
    waveform = waveform.* window';                   % apply window
    seq_vowel1 = [seq_vowel1 waveform];
end

for i = 2

    vowel_f0    = vowel_freqs(i);      % added by ST        
    waveform    = randn(1,nsamples);   % Gaussian white noise 
    waveform    = vowel.noise.amp/sqrt(mean(waveform.^2)) .* waveform; % set the amplitude using the rms of the waveform        
    
    window      = hanning(ceil(sampleRate*2*vowel.hannramp),'periodic');   % ST edit
    window      = [window(1:ceil(sampleRate*vowel.hannramp)) ; ones(nsamples-ceil(sampleRate*vowel.hannramp)-floor(sampleRate*vowel.hannramp)-1,1) ; window(floor(sampleRate*vowel.hannramp)+1:end)]; % build hanning window for stimulus
    
    waveform    = waveform.* window';                   % apply window
    seq_noise   = [seq_noise waveform];
    
end


for i = 3:4
        
    % creating formant filters with bandwiths
    nsecs       = length(vowel.formants);
    R           = exp(-pi*vowel.bandwidth/sampleRate);   % Pole radii (see Pole-zero plot)
    theta       = 2*pi*vowel.formants_all(i,:)/sampleRate;         % Pole angles
    poles       = R .* exp(j*theta);        % Complex poles
    B           = 1;
    A           = real(poly([poles,conj(poles)]));
    
    vowel_f0 = vowel_freqs(i);      % added by ST
    waveform = [];
    
    w0T = 2*pi*vowel_f0/sampleRate;                 % radians per sample
    
    nharm = floor((sampleRate/2)/vowel_f0);         % number of harmonics
    sig = zeros(1,nsamples);
    n = 0:(nsamples-1);
    
    if strcmp(vowel.carrier,'clicktrain')
        % use click train as carrier
        sig      = zeros(1,nsamples);
        interval = round(sampleRate/vowel_f0);% * 0.5 cause this is going to have positive and negative impulses
        sig(1:interval:nsamples) = 1;
        sig(2:interval:nsamples) = -1;
    else
        
        % use bandlimited impulse train as carrier
        for i=1:nharm,
            sig = sig + cos(i*w0T*n);
        end;
        sig = sig/max(sig);
    end
    
    % create sound vector
    waveform = filter(1,A,sig);
    waveform = vowel.amp/sqrt(mean(waveform.^2)) .* waveform; % set the amplitude using the rms of the waveform
    
    window = hanning(ceil(sampleRate*2*vowel.hannramp),'periodic');   % ST edit
    window = [window(1:ceil(sampleRate*vowel.hannramp)) ; ones(nsamples-ceil(sampleRate*vowel.hannramp)-floor(sampleRate*vowel.hannramp)-1,1) ; window(floor(sampleRate*vowel.hannramp)+1:end)]; % build hanning window for stimulus
    
    waveform = waveform.* window';                   % apply window
    seq_vowel34 = [seq_vowel34 waveform];
end

seq_vowel = [seq_vowel1 seq_noise seq_vowel34];

%% make vowel sequence

pre_silence  = zeros(1,round(vowel.preisi*sampleRate));
post_silence = zeros(1,round(vowel.postisi*sampleRate));
stim         = [pre_silence seq_vowel post_silence];

% if vowel.ear does not exist, play binaurally (default)
if(~isfield(vowel,'ear'))
    stim = repmat(stim, nChannels, 1);
    
else % else present monoaurally
    
    if(getfield(vowel,'ear') == 1) % left ear
        stim = stim(vowel.ear,:);
    elseif(getfield(vowel,'ear') == 2) % right ear
        stim = stim(vowel.ear,:);
    end
    
end
        


