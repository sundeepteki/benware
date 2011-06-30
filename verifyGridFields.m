function verifyGridFields(grid)
% verifyGridFields(grid)
%
% checks that a grid has all the necessary fields for BenWare.

required_fields = {'name', 'sampleRate', 'stimGenerationFunctionName', ...
'stimGridTitles', ...
'stimGrid', 'stimLevelOffsetDB', ...
'postStimSilence'};

if isequal(grid.stimGenerationFunctionName,'loadStereo')
  required_fields(end+1:end+2) = {'stimDir', 'stimFilename'};
end

fields = fieldnames(grid);
missing_fields = setdiff(required_fields, fields);

% finish now if all required fields are present
if isempty(missing_fields)
  return
end

str = 'missing fields: ';
for ii=1:L(missing_fields)
  str = [str missing_fields{ii} ', '];
end
str = droptail(str, 2);

error('grid:error', str);