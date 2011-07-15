function printExpt(expt)
% print expt structure

fprintf_subtitle('experiment');
fprintf('  - experiment #: %d\n', expt.exptNum);
fprintf('  - penetration #: %d\n', expt.penetrationNum);

fprintf('  - LHS probe: %s \n', num2str(expt.probe.lhs));
fprintf('  - RHS probe: %s \n', num2str(expt.probe.rhs));
fprintf('  - LHS headstage: %s \n', num2str(expt.headstage.lhs));
fprintf('  - RHS headstage: %s \n', num2str(expt.headstage.rhs));