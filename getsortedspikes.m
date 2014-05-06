function data = getclusteredspikes(dir)
% function data = getclusteredspikes(dir)
% scan a directory for .kwik files and load them
%
% dir = benware data directory containing sorted data
%       e.g. /Users/ben/data/P10-mistuning

data = struct;
data.gridInfoFile = [dir filesep 'gridInfo.mat'];

l = load(data.gridInfoFile);
data.grid = l.grid;
data.expt = l.expt;

% infer probe layout
probes = l.expt.probes;
layout = {};

for ii = 1:length(probes)
  if strcmp(probes(ii).layout, 'Warp-16')
    layout{ii} = [16 1];

  elseif probes(ii).layout(1)=='A'
    res = regexp(probes(ii).layout, 'A([0-9]+)x([0-9]+)', 'tokens');
    nShanks = eval(res{1}{1});
    nSites = eval(res{1}{2});
    layout{ii} = [nShanks nSites];

  else
    error('unknown probe layout -- talk to ben');
  end
end
orig_probes = probes;

fprintf('Loading data from shanks ')
probes = {};
shankNum = 1;
for probeIdx = 1:length(layout)
  probe = struct;
  probe.name = orig_probes(probeIdx).layout;
  probe.layout = layout{probeIdx};
  shanks = {};
  for shankIdx = 1:probe.layout(1)
    shank = struct;
    shank.shankIdx = shankIdx;
    shank.shankNum = shankNum;
    sprintf([dir filesep 'shank.%d' filesep '*kwik'], shankNum);
    f = getfilesmatching(sprintf([dir filesep 'shank.%d' filesep '*kwik'], shankNum));
    if isempty(f)
      shank.kwikfile = '';
      shank.cluster = {};
      fprintf('.');
    else
      shank.kwikfile = f{1};
      shank.cluster = getkwikspikes(shank.kwikfile);
      fprintf('o');
    end
    shanks{shankIdx} = shank;
    shankNum = shankNum + 1;
  end
  probe.shank = [shanks{:}];
  probes{probeIdx} = probe;
end
probes = [probes{:}];
fprintf('\n');

data.probeData = probes;

if ~isempty(data.grid.saveName)
  name = data.grid.saveName;
 else 
   name = data.grid.name;
end
save(sprintf([dir filesep 'P%02d-%s.sortedspikes.mat'], data.expt.penetrationNum, name), 'data');
