function grid = loadCompensationFilters(grid, expt)
% load compensation filters
l = load(grid.compensationFilterFile);

for ii = 1:length(grid.compensationFilterVarNames)
	grid.compensationFilters{ii} = eval(['l.' grid.compensationFilterVarNames{ii}]);
	fprintf(['Loaded compensation filter for channel ' num2str(ii) ' from ' escapepath(grid.compensationFilterFile) '\n']);
end
