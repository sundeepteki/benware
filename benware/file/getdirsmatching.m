function data = getdirsmatching(searchstring)

if ispc
    data = getfilesmatching(searchstring);
else
  list = ls('-Cd', searchstring);
  lines = strsplit(list,'\n');
  files = {};
  for ii = 1:length(lines)
    f = strsplit(lines{ii}, '\t');
    files(end+1:end+length(f)) = f;
  end
  if length(files{end})==0
    files = files(1:end-1);
  end
  data = sort(files)';
end
