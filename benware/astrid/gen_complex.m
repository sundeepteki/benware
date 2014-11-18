function waveform = gen_complex(f0,basefreq,numcomponents,amps,shifts,phases,stimlen,fs,windowlen)
% gen_complex() -- generates complex waveform
%   Usage: 
%      waveform = gen_complex(f0,basefreq,numcomponents,amps,shifts,phases,stimlen,fs,windowlen)
%   Parameters:
%      f0              fundamental frequency
%      basefreq        base frequency
%      numcomponents   number of components in complex sound
%      amps            vector with amplitudes (Pascal) of each component 
%      shifts          vector with frequency shift of each component to allow mistuning 
%      phases          vector with phaseshift for each component
%      stimlen         duration of complex waveform
%      fs              sampling frequency
%      windowlen       duration of hanning window at start and end, default is 25 ms (optional)
%   Outputs:
%      waveform        vector containing complex waveform
%
% Author: stef@nstrahl.de
% Version: $Id: gen_complex.m 156 2014-04-14 20:35:10Z stefan $

if ~exist('windowlen','var'), windowlen=25e-3; end         % if undefined the window len is 25 ms

t = 0:1/(fs-1):stimlen;                                    % time vector in sampling frequency resolution
nsamples = length(t);
temp = hann(ceil(fs*2*windowlen),'periodic');              % generate hanning window
window = ones(nsamples,1);
window(1:ceil(fs*windowlen)) = temp(1:ceil(fs*windowlen));
window(end-ceil(fs*windowlen):end) = temp(floor(fs*windowlen):end);

% harmonic complex stimulus
s = zeros(numcomponents,length(t));                        % init memory for harmonics
for h=1:numcomponents                                      % for all harmonics
    s(h,:) = amps(h)*sqrt(2) .* sin( (basefreq+(h-1)*f0+shifts(h))*t*2*pi + phases(h)); % compute time signal with amp being RMS of sinusoidal
end
% s = repmat(amps',[1 nsamples]) .* sin( (basefreq+f0*repmat((0:numcomponents-1)',[1 nsamples])+repmat(shifts',[1 nsamples])).*repmat(t,[numcomponents 1])*2*pi + repmat(phases',[1 nsamples])); % compute time signal

waveform = sum(s,1);                                       % add sinus to waveform
waveform = waveform.* window';                             % apply window