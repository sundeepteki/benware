function spikedetektDir = getLastSpikedetektDir(parentDir)

try
  spikedetektDirs = getdirsmatching([dir filesep 'spikedetekt_*']);
catch
  spikedetektDir = '';
  return;
end

% get rid of spurious null
spikedetektDirs = spikedetektDirs(cellfun(@(x) ~isempty(x), spikedetektDirs));

% sort to get the last one
if isempty(spikedetektDirs)
  spikedetektDir = '';
  return;
end
  
res = cellfun(@(x) regexp(x, 'spikedetekt_([0-9]+)', 'tokens'), spikedetektDirs, 'uni', false);
n = cellfun(@(x) eval(x{1}{1}), res)';
[srt, idx] = sort(n);
spikedetektDirs = spikedetektDirs(idx);
spikedetektDir = spikedetektDirs{end};
