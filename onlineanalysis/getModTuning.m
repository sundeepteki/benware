addpath('.');
%baseDir = 'e:\auditory-objects.data\expt%E/';
baseDir = '~/scratch/onlineanalysis/';
exptNumber = 98;

t_min = 10; % parameters of spike window
t_max = 40;

exptPattern = [baseDir 'expt%E/'];
exptDir = regexprep(exptPattern, '%E', num2str(exptNumber));
subdirName = chooseOntehflyDirectory(exptDir);
dataDir = [exptDir subdirName '/'];

% get the spikes from the benware files
data = collectOnlineSpikes2(dataDir);

% find out what freqs and levels were used
freqParam = find(strcmp(data.grid.stimGridTitles, 'ModulationFrequency'));
freqs = unique(data.grid.stimGrid(:,freqParam));
n_freqs = length(freqs);

levParam = find(strcmp(data.grid.stimGridTitles, 'Level'));
levs = unique(data.grid.stimGrid(:,levParam));
n_levs = length(levs);

durParam = find(strcmp(data.grid.stimGridTitles, 'Duration'));
dur = max(data.grid.stimGrid(:,durParam));
t = 0:1:dur; % 1ms time bins
n_t = length(t)-1; % number of bins, not length of t

n_chans = data.expt.nChannels;

% collect data into convenient format
spikes = zeros(n_t, n_levs, n_freqs, n_chans);

% loop through sets calculating PSTHes for each combination of parameters
n_sets = length(data.sets);
for setIdx = 1:n_sets
  this_set = data.sets(setIdx);
  freq_idx = find(freqs==this_set.stimParams(freqParam));
  lev_idx = find(levs==this_set.stimParams(levParam));
  
  for chanIdx = 1:n_chans
    spikeTimesPerRep = data.sets(setIdx).spikeTimes{chanIdx};
    spikeTimesAllReps = cat(1, spikeTimesPerRep{:});
    psth = histc(spikeTimesAllReps, t);
    spikes(:, lev_idx, freq_idx, chanIdx) = psth(1:end-1);
  end
end

% plot PSTHes
figure(1);
collapsed_data = squeeze(sum(sum(spikes,2), 3)); % sum over freq, level
for chan_idx = 1:n_chans
  subplot(ceil(n_chans/4), 4, chan_idx);
  bar(collapsed_data(:,chan_idx), 'histc');
  xlim([min(t) max(t)]);
end

% plot FRAs
t_min_idx = find(t>=t_min, 1);
t_max_idx = find(t<t_max, 1, 'last');
fra_data = spikes(t_min_idx:t_max_idx, :, : , :);
fra_data = squeeze(sum(fra_data, 1));

figure(2);
for chan_idx = 1:n_chans
  subplot(ceil(n_chans/4), 4, chan_idx);
  imagesc(fra_data(:,:,chan_idx));
  set(gca, 'xtick', [], 'ytick', []);
  axis xy;
end

xl = xlim;
set(gca, 'xtick', xl, 'xticklabel', [min(freqs) max(freqs)]);
yl = ylim;
set(gca, 'ytick', yl, 'yticklabel', [min(levs) max(levs)]);

