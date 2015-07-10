function makekwikparams(expt, grid)

gridName = grid.name;

fprintf('Making spikedetekt parameter file...');

% get current directory
S = dbstack('-completenames');
parts = strsplit(S(1).file, {'/' '\'});
clustering_dir = strjoin(parts(1:end-1), filesep);

params = '';
fid=fopen([clustering_dir filesep 'params.prm'], 'r');
while 1
  tline = fgets(fid);
  if ~ischar(tline), break, end
  params = [params tline];
end
fclose(fid);

% file list
file_list = '[ ';
for sweepIdx = 1:grid.nSweepsDesired
  filename = constructDataPath(expt.dataFilename, grid, expt, sweepIdx);
  file_list = [file_list '''' filename '''' ', '];
end
file_list = [file_list ' ]'];

% insert parameters into file
params = regexprep(params, '%EXPERIMENT_NAME%', gridName);
params = regexprep(params, '%FILES_LIST%', file_list);
params = regexprep(params, '%PROBE_FILE%', [gridName '.probe']);
params = regexprep(params, '%SAMPLE_RATE%', sprintf('%0.6f', expt.dataDeviceSampleRate));
params = regexprep(params, '%N_CHANNELS%', sprintf('%d', expt.nChannels));

paramsFile = constructDataPath([expt.dataDir filesep gridName '.params'], grid, expt, 1);
fid = fopen(paramsFile, 'w');
fprintf(fid, params);
fclose(fid);
fprintf('done\n');

fprintf('Making probe adjacency map...');
probes = expt.probes;
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

probeFile = constructDataPath([expt.dataDir filesep gridName '.probe'], grid, expt, 1);
makeadjacencygraph2(layout, probeFile);

nSitesPerShank = [];
for ii = 1:length(layout)
  nSitesPerShank = [nSitesPerShank repmat(layout{ii}(2), [1 layout{ii}(1)])];
end

%save([expt.dataDir filesep 'sweep_info.mat'], 'filenames', 'sweepLens', 'paramsFile', 'nSitesPerShank');

fprintf('done\n');
