function visualBell(s)
% expt = makeExpt
%
% Update the values in the expt structure and save it
%
% Run this when you start a new experiment

l = load('expt.mat');
expt = l.expt;

if exist('s', 'var')
  if strcmp(s, 'on')
    expt.visualBell = true;
  else
    expt.visualBell = false;
  end
else
  expt.visualBell = ~expt.visualBell;
end

if expt.visualBell
  onString = 'on';
else
  onString = 'off';
end

fprintf(['Visual bell is now ' onString '\n']);

if exist('expt.mat', 'file')
  movefile expt.mat expt.mat.old
end

save expt.mat expt