function int16write(data, filename, mult, append)

if ~exist('append', 'var')
  append = false;
end

if append
  mode = 'a';
else
  mode = 'w';
end

if ~exist('mult', 'var')
  mult = 1;
end

d = round(data*mult);

if any(d<-32767) || any(d>32767)
  fprintf('Range: %d to %d\n', min(d), max(d));
  error('Number outside 16-bit integer range');
end


f = fopen(filename, mode);
if (f==-1)
  error('Could not open file');
else
  fwrite(f, d, 'int16');
  fclose(f);
end
