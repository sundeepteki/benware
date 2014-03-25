function int16write(data, filename, mult, compress)

if ~exist('compress', 'var')
  compress = false;
end

if ~exist('mult', 'var')
  mult = 1;
end

d = round(data*mult);

if any(d<-32767) || any(d>32767)
  fprintf('Range: %d to %d\n', min(d), max(d));
  error('Number outside 16-bit integer range');
end


f = fopen(filename,'w');
if (f==-1)
  error('Could not open file');
else
  fwrite(f, d, 'int16');
  fclose(f);
end

if compress
  gzip(filename);
  delete(filename);
end
