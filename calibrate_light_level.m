%datadir = '~/scratch/P00-noise_with_light.9';
%datadir = '/Volumes/vonbraun.dpag.ox.ac.uk/James/data/expt33/P02-noise_with_light.2';
datadir = 'E:/James/data/expt37/P03-noise_with_light';
dt = 25; % ms bins for PSTH
latency = 0; % ms latency
max_t = 750;

%%
if ~exist('stepplot', 'file') && exist('../benlib', 'dir')
  addpath(genpath('../benlib'));
end

%%
data = collectOnlineSpikes(datadir);
%data = data_3;

stimParams = cat(1, data.sets(:).stimParams);
length_param_idx = find(strcmp(data.sets(1).stimGridTitles, 'Stimulus Length (ms)'));
sweepLen = data.sets(1).stimParams(length_param_idx);
t = 25:dt:max_t;

% window for counting spikes in response to noise
noiseon_param_idx = find(strcmp(data.sets(1).stimGridTitles, 'Noise Delay (ms)'));
noise_on = data.sets(1).stimParams(noiseon_param_idx);

noiseoff_param_idx = find(strcmp(data.sets(1).stimGridTitles, 'Noise Length (ms)'));
noise_off = noise_on + data.sets(1).stimParams(noiseoff_param_idx);

noise_window = [noise_on noise_on+50];
spike_window = noise_window+latency;

% window for counting spikes overall
lighton_param_idx = find(strcmp(data.sets(1).stimGridTitles, 'Light delay (ms)'));
light_on = data.sets(1).stimParams(lighton_param_idx);

lightoff_param_idx = find(strcmp(data.sets(1).stimGridTitles, 'Light Duration (ms)'));
light_off = light_on + data.sets(1).stimParams(lightoff_param_idx);

light_window = [light_on light_off];
light_spike_window = light_window+[25 -25]; % trim to avoid light-related artefacts

% light voltage
voltage_param_idx = find(strcmp(data.sets(1).stimGridTitles,'Light voltage (V)'));
%voltages = unique(stimParams(:,voltage_param_idx));

n_sets = length(data.sets);
n_sites = length(data.sets(1).spikeTimes);

clf;

leg = {};
r_noise = nan(n_sets,n_sites);
r_noise_all = cell(n_sets,n_sites);
r_mean = nan(n_sets,n_sites);

for set_idx = 1:n_sets
  st = data.sets(set_idx);
  leg{set_idx} = sprintf('%dV', st.stimParams(voltage_param_idx));
  for site_idx = 1:n_sites
    r_noise_all{set_idx, site_idx} = cellfun(@(x) sum(x>=spike_window(1)&x<spike_window(2)), st.spikeTimes{site_idx});
    allspikes = cat(1, st.spikeTimes{site_idx}{:});
    r_noise(set_idx, site_idx) = sum(allspikes>=spike_window(1)&allspikes<spike_window(2));
    r_mean(set_idx, site_idx) = ...
        sum(allspikes>=light_spike_window(1)&allspikes<light_spike_window(2));
    %r_mean(set_idx, site_idx) = length(allspikes)/length(st.spikeTimes{site_idx});
    p = histc(allspikes, t);
    subplotbw(ceil(n_sites/4), 4, site_idx);
    pl = stepplot(t, p');
    set(pl, 'linewidth', 2);
    hold all;
    yl = ylim;
    set(gca, 'xlim', [0 max(t)], 'ytick', [0 yl(2)]);
    if site_idx<n_sites-3
      set(gca, 'xtick', []);
    end
    drawnow;
  end
end

noise_ratio = r_noise(2,:)./r_noise(1,:);
mean_ratio = r_mean(2,:)./r_mean(1,:);

for site_idx = 1:n_sites
  subplotbw(ceil(n_sites/4), 4, site_idx);
  xl = xlim;
  yl = ylim;
  plot(noise_window, [0 0]+yl(2)/30*3, 'linewidth', 2);
  plot(spike_window, [0 0]+yl(2)/30*4, 'linewidth', 2);
  plot(light_window, [0 0]+yl(2)/30, 'linewidth', 2);
  plot(light_spike_window, [0 0]+yl(2)/30*2, 'linewidth', 2);

  [h,p] = ttest2(r_noise_all{1,site_idx},r_noise_all{2,site_idx});
  if p<0.01
    sig='**';
  elseif p<0.05
    sig = '*';
  else
    sig='';
  end
  str = sprintf('PK=%0.2f%s, MN=%0.2f', noise_ratio(site_idx), sig, mean_ratio(site_idx));
  text(xl(2),yl(2),str, 'horizontalalignment', 'right', 'verticalalignment', 'top');
  hold off;
end

subplotbw(ceil(n_sites/4), 4, n_sites-3);
ylabel('Spikes/s')
xlabel('ms')
legend(leg, 'location', 'southeast');


