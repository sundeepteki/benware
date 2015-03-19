function grid = getGridForStimDir(stimDir)

grid = struct;

files = dir(stimDir);

stimFiles = [];
for ii = 1:length(files)
  if ~files(ii).isdir && strcmp(files(ii).name(end-3:end), '.wav')
    stimFiles{end+1} = [stimDir filesep files(ii).name];
  end
end

if isempty(stimFiles)
  errorBeep(sprintf('No .wav files found in %s', stimDir));
end
[y, fs] = wavread(stimFiles{1});

sampleRates =   [0.125 0.25 0.5 1 2 4 8]*tdt50k;
sampleRateIdx = find((abs(fs-sampleRates)<1));

if isempty(sampleRateIdx)
  errorBeep(sprintf('Sample rate of %s is not a TDT supported sample rate', stimFiles{1}));
end

grid.sampleRate = sampleRates(sampleRateIdx);
grid.stimGenerationFunctionName = 'loadNamedStereoFile';
grid.stimFiles = stimFiles;
grid.stimGridTitles = {'Stimulus file (index into grid.stimFiles)'};
grid.stimGrid = (1:length(stimFiles))';

paramsFile = [stimDir filesep 'parameters.txt'];
if exist(paramsFile, 'file')
    f = fopen(paramsFile);

    data = fgetl(f);
    while ischar(data)
        r=regexp(data,' |=|:','split');
        name = r{1};
        value = r{end};

        try
           value = eval(value);
        catch
            errorBeep(sprintf('Non-numerical value or formatting error in %s', paramsFile));
        end
        
        if length(r)>2 && strcmpi(name(1:3), 'rep')
          grid.repeatsPerCondition = value;
        elseif length(r)>2 && strcmpi(name, 'leveloffsetdb')
          grid.levelOffsetDB = value;
        else
          grid = setfield(grid, name, value);
        end
        data = fgetl(f);
    end
end

if ~isfield(grid, 'repeatsPerCondition')
    grid.repeatsPerCondition = 20;
end
