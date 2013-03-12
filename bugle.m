function bugle(s)
% expt = makeExpt
%
% Update the values in the expt structure and save it
%
% Run this when you start a new experiment

loadexpt;

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

saveexpt;
