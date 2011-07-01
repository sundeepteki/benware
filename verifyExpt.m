function verifyExpt(grid, expt)
% verifyExpt(grid, expt)
% 
% checks that all is ok by the user

fprintf_title('BenWare parameters');

% experiment
fprintf_subtitle('experiment');
fprintf('  - experiment #: %d\n', expt.exptNum);
fprintf('  - penetration #: %d\n', expt.penetrationNum);
if isnumeric(expt.probe.lhs)
  fprintf('  - LHS probe: %d \n', expt.probe.lhs);
  fprintf('  - RHS probe: %d \n', expt.probe.rhs);
else
  fprintf('  - LHS probe: %s \n', expt.probe.lhs);
  fprintf('  - RHS probe: %s \n', expt.probe.rhs);
end
fprintf('  - LHS headstage: %d \n', expt.headstage.lhs);
fprintf('  - RHS headstage: %d \n', expt.headstage.rhs);

r = demandinput('\nIs this ok? [Y/n]: ', {'y', 'n'}, 'y', true);
if r=='n'
errorBeep('parameter:error', 'Error in verifyExpt');
end

% stimulus
fprintf_subtitle('stimulus');
fprintf('  - name: %s\n', grid.name);
fprintf('  - sample rate: %d\n', round(grid.sampleRate));
fprintf('  - # sets: %d\n', size(grid.stimGrid, 1));
fprintf('  - # repeats: %d\n', grid.repeatsPerCondition);
fprintf('  - # sweeps: %d\n', size(grid.stimGrid, 1) * grid.repeatsPerCondition);

if isequal(grid.stimGenerationFunctionName, 'loadStereo')
fprintf('  - stimulus dir: %s\n', split_path(constructStimPath(grid, expt, 1)));
end


r = demandinput('\nIs this ok? [Y/n]: ', {'y', 'n'}, 'y', true);
if r=='n'
errorBeep('parameter:error', 'Error in verifyExpt');
end

% recording
fprintf_subtitle('recording');
fprintf('  - data dir: %s\n', ...
constructDataPath(expt.dataDir, grid, expt))

r = demandinput('\nIs this ok? [Y/n]: ', {'y', 'n'}, 'y', true);
if r=='n'
errorBeep('parameter:error', 'Error in verifyExpt');
end
