function bugle(s)
% expt = makeExpt
%
% Update the values in the expt structure and save it
%
% Run this when you start a new experiment

l = load('expt.mat');
expt = l.expt;

if exist('s', 'var')
  if strcmp(s, 'on')
    expt.bugle = true;
  else
    expt.bugle = false;
  end
else
  expt.bugle = ~expt.bugle;
end

if expt.bugle
  onString = 'on';
else
  onString = 'off';
end

fprintf(['Bugle is now ' onString '\n']);

if exist('expt.mat', 'file')
  movefile expt.mat expt.mat.old
end

save expt.mat expt