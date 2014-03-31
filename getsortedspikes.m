function data = getclusteredspikes(dir)

data = struct;
data.gridInfo = [dir filesep 'gridInfo.mat'];

l = load(data.gridInfo);

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

fprintf('Loading data from shanks ')
probes = {};
shankNum = 1;
for probeIdx = 1:length(layout)
  probe = struct;
  probe.layout = layout{probeIdx};
  shanks = {};
  for shankIdx = 1:probe.layout(1)
    shank = struct;
    shank.shankIdx = shankIdx;
    shank.shankNum = shankNum;
    try
      sprintf([dir filesep 'shank.%d' filesep '*kwik'], shankNum);
      f = getfilesmatching(sprintf([dir filesep 'shank.%d' filesep '*kwik'], shankNum));
      shank.kwikfile = f{1};
      shank.cluster = getkwikspikes(shank.kwikfile);
      fprintf('o');
    catch
      shank.kwikfile = '';
      shank.cluster = {};
      fprintf('.');
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
