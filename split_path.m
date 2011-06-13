function dir = split_path(path)

f = find(path=='\' | path=='/',1,'last');
dir = path(1:f);