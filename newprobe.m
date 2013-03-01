function newProbe
% newProbe
%
% Update the probe and headstage IDs in the expt structure and save it
%
% Run this when you change a probe or headstage

l = load('expt.mat');
expt = l.expt;

fprintf('\nType the new IDs or hit return to leave unchanged.\n\n');
i = input(sprintf('LHS probe ID: [%s] ', num2str(expt.probe.lhs)), 's');
if ~isempty(i)
  expt.probe.lhs = i;
end

i = input(sprintf('RHS probe ID: [%s] ', num2str(expt.probe.rhs)), 's');
if ~isempty(i)
  expt.probe.rhs = i;
end

i = input(sprintf('LHS headstage ID: [%s] ', num2str(expt.headstage.lhs)), 's');
if ~isempty(i)
  expt.headstage.lhs = i;
end

i = input(sprintf('RHS headstage ID: [%s] ', num2str(expt.headstage.rhs)), 's');
if ~isempty(i)
  expt.headstage.rhs = i;
end

printExpt(expt);

if exist('expt.mat', 'file')
  movefile expt.mat expt.mat.old
end

save expt.mat expt