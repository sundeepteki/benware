function newestDir = findNewestSubdir(dirname)

d = dir(dirname);

% remove '.' and '..'
d = d(cellfun( @(x) ~strcmp(x,'.'), {d(:).name}));
d = d(cellfun( @(x) ~strcmp(x,'..'), {d(:).name}));

if isempty(d)
  newestDir = [];
  return;
end

[dummy, idx] = sort([d(:).datenum]);

newestDir = d(idx(end));
