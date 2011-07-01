function verifyStimFilesExist(grid, expt)
% verifyStimFilesExist(grid, expt)
%
% Passes if all the stimulus files referenced in the grid exist
% Raises an error if any do not exist.

% create a dummy grid, where each stimulus played once
% this is only used for getting the unique filenames

gridDummy = grid;
gridDummy.randomisedGrid = grid.stimGrid;

% get filenames
nStimConditions = size(grid.stimGrid, 1);
filenames = cell(nStimConditions, 2);
for ii=1:nStimConditions
filenames{ii, 1} = constructStimPath(gridDummy, expt, ii, 'L');
filenames{ii, 2} = constructStimPath(gridDummy, expt, ii, 'R');
end

% which do not exist
filesExist = cellfun(@(x) exist(x, 'file'), filenames);

% are we done
if all(filesExist(:))
return
end

% raise error
missingFilesStr = 'missing files:';
for ii=1:L(filenames(:))
if ~filesExist(ii)
  missingFilesStr = [missingFilesStr '\n  - ' regexprep(filenames{ii},'\','\\\')];
end
end

error('stimulus:files', missingFilesStr);