function grid = loadDefaultCompensationFilters(grid, expt)
% load default compensation filters

global OLDCOMPENSATION

if OLDCOMPENSATION
    fprintf('== WARNING: OLDCOMPENSATION=true.\n');
    fprintf('== Filters from grid will be used\n');
    fprintf('== This will soon be an error\n');
    return;
end

compensationFilterFile = expt.compensationFilterFile;

if ~ispc
  fprintf('== Using FAKE compensation filters from ./benware/fakeCompensationFilters\n');
  compensationFilterFile = fix_slashes('./benware/fakeCompensationFilters/compensation_filters.mat');
end

% load filters for all sample rates
l = load(compensationFilterFile);

% put filters for grid.sampleRate into grid.compensationFilters
calib_idx = find([l.calibs.sampleRate]==grid.sampleRate);
if length(calib_idx)<0
    error('Did not find a calibration corresponding to the sample rate of this grid.');
elseif length(calib_idx)>1
    error('Found more than one calibration corresponding to the sample rate of this grid.');
end
calib = l.calibs(calib_idx);

grid.compensationFilters = {};
for ii = 1:length(calib.channels)
  grid.compensationFilters{ii} = calib.channels(ii).filter;
end

grid.rmsVoltsPerPascal = calib.reftone_rms_volts_per_pascal;

fprintf(['== Loaded compensation filters for ' num2str(ii) ' channels from ' escapepath(compensationFilterFile) '\n']);
