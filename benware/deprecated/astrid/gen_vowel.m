function waveform = gen_vowel(vowel_dur,amplitude,fs,f0,formants,bandwidths,carriertype,hannramp)
% gen_vowel() -- generates vowels
%   Usage:
%      waveform = gen_vowel(vowel_dur,fs,f0,formants,bandwidths,windowlen)
%   Parameters:
%      vowel_dur         duration of vowel (sec)
%      amplitude       amplitude of vowel (Pascal)
%      fs              sampling frequency (Hz)
%      f0              fundamental frequency (Hz)
%      formants        vector with formant frequencies (Hz)
%      bandwidths      vector with formant bandwidths (Hz)
%      carriertype     'clicktrain' uses +1/-1 click trains (default), otherwise bandlimited impulse train is used
%      hannramp        duration of Hann ramp at start and end of waveform [default 25 ms] (sec)
%   Outputs:
%      waveform        vector containing vowel
%
% Vowel [a]
% frequencies = [700, 1220, 2600];
% bandwidths  = [130,   70,  160];
%
% Author: astrid.klinge@googlemail.com & stef@nstrahl.de
% Version: $Id:$

if ~exist('hannramp','var'), hannramp=5e-3; end            % if undefined the Hann ramp is 5 ms
if ~exist('carriertype','var'), carriertype='clicktrain'; end   % if undefined the default is +1/-1 click train

t = 0:1/(fs-1):vowel_dur;                                    % time vector in sampling frequency resolution
nsamples = length(t);

% creating formant filters with bandwiths (Smith, J.O. Introduction to Digital Filters with Audio Applications,
% https://ccrma.stanford.edu/~jos/filters/Formant_Filtering_Example.html, online book,
% accessed 29-10-2013.)
nsecs = length(formants);
R     = exp(-pi*bandwidths/fs);   % Pole radii (see Pole-zero plot)
theta = 2*pi*formants/fs;         % Pole angles
poles = R .* exp(j*theta);        % Complex poles
B     = 1;
A     = real(poly([poles,conj(poles)]));

% Convert to parallel complex one-poles (PFE):
[r,p,f] = residuez(B,A);
As      = zeros(nsecs,3);
Bs      = zeros(nsecs,3);
% complex-conjugate pairs are adjacent in r and p:
for i=1:2:2*nsecs
   k       = 1+(i-1)/2;
   Bs(k,:) = [r(i)+r(i+1),  -(r(i)*p(i+1)+r(i+1)*p(i)), 0];
   As(k,:) = [1, -(p(i)+p(i+1)), p(i)*p(i+1)];
end

% Now synthesize the vowel
w0T = 2*pi*f0/fs;                 % radians per sample

nharm = floor((fs/2)/f0);         % number of harmonics
sig = zeros(1,nsamples);
n = 0:(nsamples-1);

if strcmp(carriertype,'clicktrain')
   % use click train as carrier
   sig      = zeros(1,nsamples);
   interval = round(fs/f0);% * 0.5 cause this is going to have positive and negative impulses
   sig(1:interval:nsamples) = 1;
   sig(2:interval:nsamples) = -1;
else
   % use bandlimited impulse train as carrier
   for i=1:nharm,
      sig = sig + cos(i*w0T*n);
   end;
   sig = sig/max(sig);
end

waveform = filter(1,A,sig);
waveform = amplitude/sqrt(mean(waveform.^2)) .* waveform; % set the amplitude using the rms of the waveform

window = hann(ceil(fs*2*hannramp),'periodic');   % generate hanning window
window = [window(1:ceil(fs*hannramp)) ; ones(nsamples-ceil(fs*hannramp)-floor(fs*hannramp)-1,1) ; window(floor(fs*hannramp)+1:end)]; % build hanning window for stimulus
waveform = waveform.* window';                   % apply window
