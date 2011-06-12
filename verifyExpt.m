function verifyExpt(grid, expt)
  % verifyExpt(grid, expt)
  % 
  % checks that all is ok by the user

fprintf_title('BenWare parameters');

% experiment
fprintf_subtitle('experiment');
fprintf('  - experiment #: %d\n', expt.exptNum);
fprintf('  - penetration #: %d\n', expt.penetrationNum);
fprintf('  - LHS probe: %d \n', expt.probe.lhs);
fprintf('  - RHS probe: %d \n', expt.probe.lhs);
fprintf('  - LHS headstage: %d \n', expt.headstage.lhs);
fprintf('  - RHS headstage: %d \n', expt.headstage.lhs);

r = demandinput('\nis this ok? [y/n]: ', {'y', 'n'});
if r=='n'
  error('parameter:error');
end

% stimulus
fprintf_subtitle('stimulus');
fprintf('  - name: %s\n', grid.name);
fprintf('  - sample rate: %d\n', round(grid.sampleRate));
fprintf('  - # sets: %d\n', size(grid.stimGrid, 3));
fprintf('  - # repeats: %d\n', grid.repeatsPerCondition);
fprintf('  - # sweeps: %d\n', ...
	size(grid.stimGrid, 3) * grid.repeatsPerCondition);
fprintf('  - stimulus dir: %s\n', ...
	split_path(constructStimPath(grid, expt, 1)));

r = demandinput('\nis this ok? [y/n]: ', {'y', 'n'});
if r=='n'
  error('parameter:error');
end

% recording
fprintf_subtitle('recording');
fprintf('  - data dir: %s\n', ...
	constructDataPath(grid.dataDir, grid, expt))

r = demandinput('\nis this ok? [y/n]: ', {'y', 'n'});
if r=='n'
  error('parameter:error');
end
