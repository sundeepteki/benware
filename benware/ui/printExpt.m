function printExpt(expt)
% print expt structure

fprintf_subtitle('Experiment');
fprintf('  - experiment #: %d\n', expt.exptNum);
fprintf('  - penetration #: %d\n', expt.penetrationNum);

printProbes(expt.probes);

fprintf('Mapping: %s\n', num2str(expt.channelMapping));
