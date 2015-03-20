function path = fixpath(path)
    % FIXPATH
    %   fixpath(path) ensures that the path ends with a '/' or '\'
    %   depending on the system
    
    % which platform
    if isunix | ismac
      directory_delimiter = '/';
    elseif ispc
      directory_delimiter = '\';
    end

    % ensure it ends with the appropriate directory_delimiter
    if ~strcmp(path(end), directory_delimiter)
      path = [path directory_delimiter];
    end
    
    path = fix_slashes(path);
    
end
