function path = fix_slashes(path)
% path = fix_slashes(path)
%
% check that the slashes are in the right direction

if isunix | ismac
  path = regexprep(path, '\', '/');

elseif ispc
  path = regexprep(path, '/', '\');
end