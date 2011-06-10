function stim = loadStimulus(stimFileL, stimFileR, stimLevelOffsetDB)

fL = fopen(stimFileL);
fR = fopen(stimFileR);
stim = [fread(fL,inf,'float32')'; fread(fR,inf,'float32')'];
stim = stim*10^(stimLevelOffsetDB/20);
fclose(fL);
fclose(fR);
