function snd = import_sound(filename)
  fid = fopen(filename,'r');
  snd = fread(fid,inf,'float32');
  fclose(fid);