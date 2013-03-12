function visualbell(s)
% function visualbell(s)
%
% Turn on and off the visual bell
% Not sure this currently works

loadexpt;

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

saveexpt;
