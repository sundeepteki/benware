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
fprintf('  - sample rate: %d\n', round(grid.sampleRate));
fprintf('  - # sets: %d\n', size(grid.stimGrid, 1));
fprintf('  - # repeats: %d\n', grid.repeatsPerCondition);
fprintf('  - # sweeps: %d\n', size(grid.stimGrid, 1) * grid.repeatsPerCondition);

if isequal(grid.stimGenerationFunctionName, 'loadStereo')
fprintf('  - stimulus dir: %s\n', split_path(constructStimPath(grid, expt, 1)));
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
