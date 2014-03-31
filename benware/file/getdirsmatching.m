function data = getdirsmatching(searchstring)

if ispc
    data = getfilesmatching(searchstring);
else
  list = ls('-C -d', searchstring);
  files = strsplit(list,'\n');
  if length(files{end})==0
    files = files(1:end-1);
  end
  data = sort(files)';
end
