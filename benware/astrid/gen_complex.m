function waveform = gen_complex(f0,basefreq,numcomponents,amps,shifts,phases,stimlen,fs,windowlen)
% gen_complex() -- generates complex waveform
%   Usage: 
%      waveform = gen_complex(fs,stim_length,f0,harmonics,shifts,phases,amps)
%   Parameters:
%      f0              basic frequency
%      basefreq        base frequency
%      numcomponents   number of components in complex sound
%      amps            vector with amplitudes of each component 
%      shifts          vector with frequency shift of each component to allow mistuning 
%      phases          vector with phaseshift for each component
%      stimlen         duration of complex waveform
%      fs              sampling frequency
%      windowlen       duration of hanning window at start and end, default is 25 ms (optional)
%   Outputs:
%      waveform        vector containing complex waveform
%
% Author: stef@nstrahl.de
% Version: $Id: gen_complex.m 113 2013-08-12 23:22:39Z stefan $

if ~exist('windowlen','var'), windowlen=25e-3; end         % if undefined the window len is 25 ms

t = 0:1/(fs-1):stimlen;                                    % time vector in sampling frequency resolution
nsamples = length(t);
window = hann(ceil(fs*2*windowlen),'periodic');            % generate hanning window
window = [window(1:ceil(fs*windowlen)) ; ones(nsamples-ceil(fs*windowlen)-floor(fs*windowlen)-1,1) ; window(floor(fs*windowlen)+1:end)]; % build hanning window for stimulus

% harmonic complex stimulus
s = zeros(numcomponents,length(t));                        % init memory for harmonics
for h=1:numcomponents                                      % for all harmonics
    s(h,:) = amps(h) .* sin( (basefreq+(h-1)*f0+shifts(h))*t*2*pi + phases(h)); % compute time signal
end
% s = repmat(amps',[1 nsamples]) .* sin( (basefreq+f0*repmat((0:numcomponents-1)',[1 nsamples])+repmat(shifts',[1 nsamples])).*repmat(t,[numcomponents 1])*2*pi + repmat(phases',[1 nsamples])); % compute time signal


waveform = sum(s,1);                                       % add sinus to waveform
waveform = waveform.* window';                             % apply window
waveform = waveform./10;                                   % Quickfix TODO: normalize to 0.1 RMS?
