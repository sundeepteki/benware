function newExpt(n)
% expt = makeExpt
%
% Update the values in the expt structure and save it
%
% Run this when you start a new experiment

l = load('expt.mat');
expt = l.expt;

if ~exist('n', 'var')
  n = expt.exptNum + 1;
end

expt.exptNum = n;
fprintf('Setting expt number to %d\n', n);

expt.penetrationNum = 0;
fprintf('Setting penetration number to 0\n');

expt.probe.lhs = input('LHS probe ID: ','s');
expt.probe.rhs = input('RHS probe ID: ','s');

expt.headstage.lhs = input('LHS headstage ID: ','s');
expt.headstage.rhs = input('RHS headstage ID: ','s');

printExpt(expt);

if exist('expt.mat', 'file')
  movefile expt.mat expt.mat.old
end

save expt.mat expt