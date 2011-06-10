function y = read_float32_file(filename)
  % y = read_float32_file(filename)
  
  fid = fopen(filename','r');
  y = fread(fid,inf,'float32');
  fclose(fid);