function stim = stimgen_st_sequencelearning_vowel(expt, grid, varargin)

%{

Function to make vowel sequences for sequence learning experiment 1A: based on Gavornik and Bear, 2014 - experiment 1 

Sundeep Teki
v1: 24-Jun-2016 22:26:53

%}


%% get parameters

sampleRate  = grid.sampleRate; 
nChannels   = expt.nStimChannels;
vowel       = grid.vowel;
% vowel.dur   = 0.3;
% % vowel.formants = [730 2058 2979 4294];            % for vowel e
% vowel.formants = [936 1551 2815 4290];            % for vowel a
vowel_freqs = cell2mat(varargin); 
% vowel_freqs = [322 913 192 543];
assert(length(vowel_freqs)==4);

%% make vowel vector

t           = 0:1/(sampleRate-1):vowel.dur;
nsamples    = length(t);

% creating formant filters with bandwiths
nsecs       = length(vowel.formants);
R           = exp(-pi*vowel.bandwidth/sampleRate);   % Pole radii (see Pole-zero plot)
theta       = 2*pi*vowel.formants/sampleRate;         % Pole angles
poles       = R .* exp(j*theta);        % Complex poles
B           = 1;
A           = real(poly([poles,conj(poles)]));

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
seq_vowel   = []; 

for i = 1:length(vowel.freqs)
    
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
    seq_vowel = [seq_vowel waveform];
end

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
        
% write sound file if required
audiowrite(['/Users/sundeepteki/Documents/Oxford/Work/Code/tekilib/#teki/stimuli/sundeep/st_sequencelearning_A_Test_x_2/st_sequencelearning_A_ABCD300.wav'],stim',97656);

