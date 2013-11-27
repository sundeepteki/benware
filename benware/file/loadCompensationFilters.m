function grid = loadCompensationFilters(grid, expt)
% load compensation filters

% fprintf('== loadCompensationFilters should no longer be used!\n');
% fprintf('== Remove the line mentioning loadCompensationFilters from your grid\n');
% fprintf('== Compensation filters are now specified using newcompfilters()\n');
% error('You must fix this to continue');

fprintf('== WARNING: Using GRID.compensationFilterFile.\n');
fprintf('== Ignoring EXPT.compensationFilterFile.\n');
fprintf('== This will soon be an error\n');

l = load(grid.compensationFilterFile);

for ii = 1:length(grid.compensationFilterVarNames)
  grid.compensationFilters{ii} = eval(['l.' grid.compensationFilterVarNames{ii}]);
  fprintf(['Loaded compensation filter for channel ' num2str(ii) ' from ' escapepath(grid.compensationFilterFile) '\n']);
end
