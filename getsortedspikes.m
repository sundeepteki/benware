function data = getsortedspikes(dir, allWaveforms, unsortedSpikes)
% function shankData = getsortedspikes(dir, allWaveforms, unsortedSpikes)
% 
% get spike data that has been manually sorted with klustaviewa
% from a benware directory
% e.g. shankData = getspikes_manual('P10-quning.1')
%
% dir: benware directory
% allWaveforms: if false, only return a maximum of 1000 spike waveforms
% unsortedSpikes: if true, return the result of automatic clustering with
% klustakwik, rather than the manually sorted clusters

setpath;

if ~exist('allWaveforms', 'var')
  allWaveforms = false;
end

if ~exist('unsortedSpikes', 'var')
  unsortedSpikes = false;
end

data = struct;
theFileSep = filesep;
data.gridInfoFile = [dir theFileSep 'gridInfo.mat'];

if ispc
  % kludge
  theFileSep = '/';
  data.gridInfoFile(data.gridInfoFile=='\') = '/';
end

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

sh = getdirsmatching([dir filesep 'shank*']);

if isempty(sh) % klustaviewa 0.3.0
  f = getfilesmatching([dir theFileSep '*.kwik']);
  assert(length(f)==1);
  kwikfile = f{1};
  fprintf(['Loading data from ' f{1} '\n']);

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
      shank.cluster = getkwikspikes_multishank(kwikfile, shankIdx, allWaveforms, unsortedSpikes);
      shanks{shankIdx} = shank;
      shankNum = shankNum + 1;
    end
    probe.shank = [shanks{:}];
    probes{probeIdx} = probe;
  end
  probes = [probes{:}];
  fprintf('\n');

else % klustaviewa < 0.3.0
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
      sprintf([dir theFileSep 'shank.%d' theFileSep '*kwik'], shankNum);
      f = getfilesmatching(sprintf([dir theFileSep 'shank.%d' theFileSep '*kwik'], shankNum));
      if isempty(f)
        shank.kwikfile = '';
        shank.cluster = {};
        fprintf('.');
      else
        shank.kwikfile = f{1};
        shank.cluster = getkwikspikes(shank.kwikfile, allWaveforms);
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
end

data.probeData = probes;

if ~isempty(data.grid.saveName)
  name = data.grid.saveName;
 else 
   name = data.grid.name;
end

if unsortedSpikes
  save(sprintf([dir theFileSep 'P%02d-%s.unsortedspikes.mat'], data.expt.penetrationNum, name), 'data', '-v7.3');
else
  save(sprintf([dir theFileSep 'P%02d-%s.sortedspikes.mat'], data.expt.penetrationNum, name), 'data', '-v7.3');

end
