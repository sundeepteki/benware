function ls2(varargin)
  files = dir(varargin{:});
  files = files(~cellfun(@(x) x(1)=='.', {files.name}));
  files = [files([files.isdir]); files(~[files.isdir])];
  for ii=1:length(files)
    sty = 'white';
    if files(ii).isdir
      sty = '-blue';
    elseif length(files(ii).name)>2 & isequal(tail(files(ii).name,2),'.m');
      sty = 'green';
    end
    cprintf(sty, [files(ii).name '\n']);
  end
  