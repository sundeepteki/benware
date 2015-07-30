addpath('.');

baseDir = 'f:\auditory-objects.data\';
%baseDir = '~/scratch/onlineanalysis/';
exptNumber = 72;

exptPattern = [baseDir 'expt%E\'];
exptDir = regexprep(exptPattern, '%E', num2str(exptNumber));
subdirName = chooseOntehflyDirectory(exptDir);
dataDir = [exptDir subdirName '\'];

% get the spikes from the benware files
data = collectOnlineSpikes2(dataDir);

% find out what freqs and levels were used
freqParam = find(strcmp(data.grid.stimGridTitles, 'Frequency'));
freqs = unique(data.grid.stimGrid(:,freqParam));
n_freqs = length(freqs);

levParam = find(strcmp(data.grid.stimGridTitles, 'Level'));
levs = unique(data.grid.stimGrid(:,levParam));
n_levs = length(levs);

durParam = find(strcmp(data.grid.stimGridTitles, 'Duration'));
toneDur = max(data.grid.stimGrid(:,durParam));

sweepDur = toneDur + data.grid.postStimSilence*1000;

binsize = 10;
t = 0:binsize:sweepDur; % 10 ms time bins
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
    if isempty(spikeTimesPerRep)
        spikeTimesAllReps = [];
        psth = zeros(n_t+1,1);
    else
        spikeTimesAllReps = cat(1, spikeTimesPerRep{:});
        psth = histc(spikeTimesAllReps, t);
    end
    spikes(:, lev_idx, freq_idx, chanIdx) = psth(1:end-1);
  end
end

% benware channels are in 4 columns, so we are going to match this
plot_order = reshape(1:n_chans,4,n_chans/4)';
plot_order = plot_order(:);

% plot PSTHes
figure(1);
collapsed_data = squeeze(sum(sum(spikes,2), 3)); % sum over freq, level
for chan_idx = 1:n_chans
  subplot(ceil(n_chans/4), 4, plot_order(chan_idx));
  hold off;
  bar(t(1:end-1),collapsed_data(:,chan_idx), 'histc');
  xlim([min(t) max(t)]);
end

% plot FRAs
laplace = [0 -1 0; -1 4 1; 0 -1 0];
fra_data = [];

% try spike windows starting between 0 and 50ms
max_t_min = find(t>=50, 1);
% spike windows end at stimulus duration at the latest
max_t_max = find(t>=toneDur, 1);

% tone duration in bins (for off window)
toneDur_bins = find(t>=toneDur, 1);

for chan_idx = 1:size(spikes,4)
    min_badness = 1e6;
    best_t_min = nan;
    best_t_max = nan;
    for t_min_idx = 1:max_t_min
        for t_max_idx = t_min_idx+1:max_t_max
            
            % on window
            on = spikes(t_min_idx:t_max_idx, :, :, chan_idx);
            on = squeeze(sum(on, 1));
            
            % first, try without off window
            this_fra = on;

            norm = this_fra-mean(this_fra(:));
            norm = norm/std(norm(:));
            lapl = conv2(norm, laplace, 'valid');
            badness = sum(lapl(:));
            if isfinite(badness) && badness<min_badness
                fra_data(:,:,chan_idx) = this_fra;
                min_badness = badness;
                best_t_min = t(t_min_idx);
                best_t_max = t(t_max_idx+1);
                best_used_off_window = false;
            end
            
            % now, try with off window
            % off window is the same as on window but toneDur later
            off = spikes(toneDur_bins+off_min_idx:toneDur_bins+off_max_idx, :, :, chan_idx);
            off = squeeze(sum(off, 1));
            
            this_fra = on - off;

            norm = this_fra-mean(this_fra(:));
            norm = norm/std(norm(:));
            lapl = conv2(norm, laplace, 'valid');
            badness = sum(lapl(:));
            if isfinite(badness) && badness<min_badness
                fra_data(:,:,chan_idx) = this_fra;
                min_badness = badness;
                best_t_min = t(t_min_idx);
                best_t_max = t(t_max_idx+1);
                best_used_off_window = true;
            end
        end
    end
    figure(1);
    subplot(ceil(n_chans/4), 4, plot_order(chan_idx));
    hold on;
    yl = ylim;
    on_line = plot([best_t_min best_t_max], [yl(2)/8 yl(2)/8], 'g-', 'linewidth', 3);
    if best_used_off_window
        off_line = plot([best_t_min+toneDur best_t_max+toneDur], [yl(2)/8 yl(2)/8], 'r-', 'linewidth', 3);
    end

    hold off;
    set(gca, 'xtick', []);

end

hold on
xl = xlim;
set(gca, 'xtick', xl);
xlabel('ms')
ylabel('Spikes')
plot([0 toneDur], [7*yl(2)/8 7*yl(2)/8], 'k-', 'linewidth', 3);
hold off



figure(2);
for chan_idx = 1:n_chans
  subplot(ceil(n_chans/4), 4, plot_order(chan_idx));
  imagesc(fra_data(:,:,chan_idx));
  set(gca, 'xtick', [], 'ytick', []);
  axis xy;
end

xl = xlim;
set(gca, 'xtick', xl, 'xticklabel', [min(freqs) max(freqs)]);
yl = ylim;
set(gca, 'ytick', yl, 'yticklabel', [min(levs) max(levs)]);
xlabel('Freq (Hz)');
ylabel('Level (dB)')
