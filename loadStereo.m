function [stim, stimInfo] = loadStereo(sweepNum,grid)

fprintf(['Loading stimulus ' num2str(number) '...']);

stimInfo.sweepNum = sweepNum;
stimInfo.stimParameters = grid.randomisedGrid(sweepNum,:);

fullPath = [grid.stimDir grid.stimFilename];
for ii = 1:length(stimInfo.stimParameters)
    [s,e] = regexp(fullpath,['%' num2str(ii)];
    
f = findstr('%N',fullName);
filename = [fullName(1:f-1) num2str(number) fullName(f+2:end)];
f = findstr('%L',filename);
stimfileL = [filename(1:f-1) 'L' filename(f+2:end)];
stimfileR = [filename(1:f-1) 'R' filename(f+2:end)];

stim = loadStimulus(stimfileL, stimfileR, grid.stimGainMultiplier);

global fs_out truncate

if truncate
    fprintf('Truncating stimulus\n');
    stim = stim(:,1:round(1.5*fs_out)); % hack to present 1 second stimulus instead of 30
end

fprintf(['done after ' num2str(toc) ' sec.\n']);
