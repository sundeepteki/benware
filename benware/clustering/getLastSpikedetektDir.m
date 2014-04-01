function spikedetektDir = getLastSpikedetektDir(parentDir)

try
  spikedetektDirs = getdirsmatching([dir filesep 'spikedetekt_*']);
catch
  spikedetektDir = '';
end

% sort to get the last one
res = cellfun(@(x) regexp(x, 'spikedetekt_([0-9]+)', 'tokens'), spikedetektDirs, 'uni', false);
n = cellfun(@(x) eval(x{1}{1}), res)';
[srt, idx] = sort(n);
spikedetektDirs = spikedetektDirs(idx);
spikedetektDir = spikedetektDirs{end};
