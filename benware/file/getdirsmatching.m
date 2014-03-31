function data = getdirsmatching(searchstring)

if ispc
    data = getfilesmatching(searchstring);
else
  list = ls('-d', searchstring);
  [st, en] = regexp(list,'\S*');

  files = {};
  for ii = 1:length(st)
    files{ii} = list(st(ii):en(ii));
  end

  data = sort(files)';
end
