function stim = loadStimulus(stimFileL, stimFileR, stimMultiplier)

fL = fopen(stimFileL);
fR = fopen(stimFileR);
stim = [fread(fL,inf,'float32')'; fread(fR,inf,'float32')']*stimMultiplier;
fclose(fL);
fclose(fR);
