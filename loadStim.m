function stim = loadStim(stimFileL, stimFileR, stimLevelOffsetDB)
  % stim = loadStim(stimFileL, stimFileR, stimLevelOffsetDB)
  %
  % Loads a stimulus from the given files.
  % Applies the offset specified by stimLevelOffsetDB

fL = fopen(stimFileL);
fR = fopen(stimFileR);
stim = [fread(fL,inf,'float32')'; fread(fR,inf,'float32')'];
stim = stim*10^(stimLevelOffsetDB/20);
fclose(fL);
fclose(fR);
