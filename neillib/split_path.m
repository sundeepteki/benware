function [directory_name file_name] = split_path(fullpath)
  % [directory file] = split_path(fullpath)
  % 
  % divides the path up in to the directory (up to the last '\' or
  % '/'), and the filename (the remainder)

  if isunix | ismac
    directory_delimiter = '/';
  elseif ispc
    directory_delimiter = '\';
  end

  idx = find(fullpath == directory_delimiter);
  idx = idx(end);
  directory_name = fullpath(1:idx);
  file_name = fullpath((idx+1):end);