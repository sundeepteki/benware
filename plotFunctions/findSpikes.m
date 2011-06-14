function [spikes,index] = findSpikes(data,index,spikeFilter)

global fs_in;

maxlen = min(cellfun(@length,data));
nChan = length(data);

datacube = zeros(maxlen-index,nChan);

spikes = findSpikesFast(datacube);

index = maxlen;

% retu
% times = signal
% 
% t.to_keep = -14:25;
% 
% % find threshold crossings
% THRESHOLD = 4; %3.5 * 1;
% smp = struct;
% smp.below_thresh = find(signal < -THRESHOLD);
% if L(smp.below_thresh)==0
%   spikes = struct;
%   spikes.time_ms = zeros(1,0);
%   spikes.time_smp = zeros(1,0);
%   return;
% end
% smp.cross_thresh = smp.below_thresh([0; diff(smp.below_thresh)]~=1);
% 
% % remove those too close to the start and end of the signal
% within_range = ...
%   (smp.cross_thresh + 19 <= L(signal));
% smp.cross_thresh = smp.cross_thresh(within_range);
% if L(smp.cross_thresh)==0
%   spikes = struct;
%   spikes.time_ms = zeros(1,0);
%   spikes.time_smp = zeros(1,0);
%   return;
% end
% 
% % spike times
% t.cross_thresh = smp.cross_thresh/fs;
% 
% % minimum time
% try
%   [a b] = min(signal(repmat(smp.cross_thresh,1,20) + repmat(0:19,L(smp.cross_thresh),1)),[],2);
%   smp.abs_minimum = smp.cross_thresh + b;
% catch
%   fprintf('failed min\n');
%   keyboard;
% end
% 
% % remove those too close to the start and end of the signal
% within_range = ...
%   (smp.abs_minimum+min(t.to_keep)>=1) ...
%   & (smp.abs_minimum+max(t.to_keep)<=L(signal));
% smp.abs_minimum = smp.abs_minimum(within_range);
% 
% % remove duplicates
% smp.abs_minimum = unique(smp.abs_minimum);
% t.abs_minimum = smp.abs_minimum/fs;
% 
% 
% 
% 
% %% output
% % =========
% 
% spikes = struct;
% spikes.time_ms = t.abs_minimum' * 1000;
% spikes.time_smp = smp.abs_minimum';
% 
% 
% end