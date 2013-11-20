function grid = loadDefaultCompensationFilters(grid, expt)
% load default compensation filters

sampleRate = ceil(grid.sampleRate/10000)*10;
compensationFilterFilename = sprintf(expt.compensationFilterFilename, sampleRate);

global fakeHardware;
if fakeHardware
  fprintf('== Using fake compensation filters from ./benware/fakeCompensationFilters\n');
  compensationFilterFile = fix_slashes(['./benware/fakeCompensationFilters/' compensationFilterFilename]);
else
  compensationFilterFile = fix_slashes([expt.compensationFilterDir '/' compensationFilterFilename]);
end

l = load(compensationFilterFile);

if isfield(l, 'compensationFilters') & isfield(l.compensationFilters, 'L')
  varnames = {'compensationFilters.L', 'compensationFilters.R'};
elseif isfield(l, 'compensationFilter')
  varnames = {'compensationFilter'};
else
  error(['I do not understand the compensation filter file ' compensationFilterFiles]);
end

for ii = 1:length(varnames)
  grid.compensationFilters{ii} = eval(['l.' varnames{ii}]);
  fprintf(['== Loaded compensation filter for channel ' num2str(ii) ' from ' escapepath(compensationFilterFile) '\n']);
end
