function stimGrid = createPermutationGrid(varargin)
% stimGrid = createPermutationGrid(params1, params2, ...)
%
% creates a grid whose rows are all combinations of the varargins.

% how many of each
nCols = length(varargin);
nConditionsPerCol = Lincell(varargin);
nConditions = prod(nConditionsPerCol);

% dummy index
x = (1:nConditions)' - 1;
idx = nan(length(x), length(varargin));
% target grid
stimGrid = idx;

% run through the columns
for ii = nCols:-1:1
  % index of that column
  idx(:, ii) = mod(x, nConditionsPerCol(ii));
  % remove that column from further computation
  x = (x - idx(:, ii)) / nConditionsPerCol(ii);
  % fill this into the stimGrid
  stimGrid(:, ii) = varargin{ii}(idx(:, ii) + 1);
end
  
