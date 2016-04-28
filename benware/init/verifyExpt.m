function [grid, expt] = verifyExpt(grid, expt)
% verifyExpt(grid, expt)
% 
% checks that all is ok by the user

fprintf_title('BenWare parameters');

% experiment
printExpt(expt);

% r = demandinput('\nIs this ok? [Y/n]: ', {'y', 'n'}, 'y', true);
% if r=='n'
% errorBeep('parameter:error', 'Error in verifyExpt');
% end

% stimulus
fprintf_subtitle('Stimulus');
fprintf('  - name: %s\n', grid.name);
if ~strcmpi(expt.stimDeviceType, 'none')
  fprintf('  - sample rate: %d\n', round(grid.sampleRate));
end
fprintf('  - # sets: %d\n', size(grid.stimGrid, 1));
fprintf('  - # repeats: %d\n', grid.repeatsPerCondition);
fprintf('  - # sweeps: %d\n', size(grid.stimGrid, 1) * grid.repeatsPerCondition);

if isfield(grid, 'stimDir')
  stimDir = constructStimPath(grid.stimDir, expt.exptNum, -1, grid.name, '', grid.randomisedGrid(1, :));
  fprintf('  - stimulus dir: %s\n', stimDir);
end


% r = demandinput('\nIs this ok? [Y/n]: ', {'y', 'n'}, 'y', true);
% if r=='n'
% errorBeep('parameter:error', 'Error in verifyExpt');
% end

% recording
%fprintf('  - data dir: %s\n', ...
%constructDataPath(expt.dataDir, grid, expt))

%r = demandinput('\nIs this ok? [Y/n]: ', {'y', 'n'}, 'y', true);
%if r=='n'
%errorBeep('parameter:error', 'Error in verifyExpt');
%end
