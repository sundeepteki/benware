function waveform = gen_ISI(stimlen,fs)
% gen_ISI() -- generates inter stimulus interval
%   Usage: 
%      waveform = gen_ISI(stimlen,fs)
%   Parameters:
%      stimlen         duration of complex waveform
%      fs              sampling frequency
%   Outputs:
%      waveform        vector containing inter stimulus interval
%
% Author: stefan.strahl@medel.com
% Version: $Id: gen_ISI.m 107 2013-08-11 21:22:10Z stefan $

waveform = zeros(1,round(stimlen*fs));   % init memory for harmonics
