function [stim, stimInfo] = loadStereo(sweepNum,grid,expt)

fprintf(['Loading stimulus ' num2str(sweepNum) '...']);

stimInfo.sweepNum = sweepNum;
stimInfo.stimulusGridTitles = grid.stimulusGridTitles;
stimInfo.stimParameters = grid.randomisedGrid(sweepNum,:);

fullPath = [grid.stimDir grid.stimFilename];
for ii = 1:length(stimInfo.stimParameters)-1
    fullPath = regexprep(fullPath,['%' num2str(ii)],num2str(stimInfo.stimParameters(ii)));
end

fullPath = regexprep(fullPath,'%E',num2str(expt.exptNum));
fullPath = regexprep(fullPath,'%P',['P' num2str(expt.penetrationNum,'%02d')]);
fullPath = regexprep(fullPath,'%N',num2str(grid.name));

stimInfo.stimfileL = regexprep(fullPath,'%L','L');
stimInfo.stimfileR = regexprep(fullPath,'%L','R');

stim = loadStimulus(stimInfo.stimfileL, stimInfo.stimfileR, grid.stimLevelOffsetDB+stimInfo.stimParameters(end));

global fs_out truncate

if truncate>0
    fprintf('Truncating stimulus\n');
    stim = stim(:,1:round(truncate*fs_out)); % hack to present 1 second stimulus instead of 30
end

fprintf(['done after ' num2str(toc) ' sec.\n']);
