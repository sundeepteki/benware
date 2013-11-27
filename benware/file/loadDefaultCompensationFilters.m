function grid = loadDefaultCompensationFilters(grid, expt)
% load default compensation filters

if ~isfield(expt, 'compensationFilterFilename')
    fprintf('== WARNING: No compensation filters specified in expt.\n');
    fprintf('== Filters from grid will be used\n');
    fprintf('== This will soon be an error\n');
    grid.compensationFilters = [];
    return;
end
sampleRate = ceil(grid.sampleRate/10000)*10;
compensationFilterFilename = sprintf(expt.compensationFilterFilename, sampleRate);

global fakeHardware;
if fakeHardware
  fprintf('== Using FAKE compensation filters from ./benware/fakeCompensationFilters\n');
  compensationFilterFile = fix_slashes(['./benware/fakeCompensationFilters/' compensationFilterFilename]);
else
  compensationFilterFile = fix_slashes([expt.compensationFilterDir '/' compensationFilterFilename]);
end

l = load(compensationFilterFile);

if isfield(l, 'compensationFilters') && isfield(l.compensationFilters, 'L')
  varnames = {'compensationFilters.L', 'compensationFilters.R'};
elseif isfield(l, 'compensationFilter')
  varnames = {'compensationFilter'};
else
  error(['I do not understand the compensation filter file ' compensationFilterFiles]);
end

for ii = 1:length(varnames)
  rawCompensationFilter = eval(['l.' varnames{ii}]);

  % set vector length to one so that filters have no overall effect on amplitude
  grid.compensationFilters{ii} = rawCompensationFilter/norm(rawCompensationFilter);
  fprintf(['== Loaded compensation filter for channel ' num2str(ii) ' from ' escapepath(compensationFilterFile) '\n']);
end
