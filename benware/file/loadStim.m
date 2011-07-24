function stim = loadStim(stimFileL, stimFileR, stimLevelOffsetDB)
% stim = loadStim(stimFileL, stimFileR, stimLevelOffsetDB)
%
% Loads a stimulus from the given files.
% Applies the offset specified by stimLevelOffsetDB
%
% If separate offsets for L and R are required, use a vector for
% stimLevelOffsetDB

% load files
fL = fopen(stimFileL);
fR = fopen(stimFileR);
stim = [fread(fL, inf, 'float32')'; fread(fR, inf, 'float32')'];

% apply offset
if length(stimLevelOffsetDB) == 1
  stim = stim * 10^(stimLevelOffsetDB / 20);
elseif length(stimLevelOffsetDB) == 2
  stim(1, :) = stim(1, :) * 10^(stimLevelOffsetDB(1) / 20);
  stim(2, :) = stim(2, :) * 10^(stimLevelOffsetDB(2) / 20);
else
  error('input:error', 'stimLevelOffsetDB must have length 1 or 2');
end

fclose(fL);
fclose(fR);
