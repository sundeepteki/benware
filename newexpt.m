function newexpt(n)
% expt = makeExpt
%
% Update the values in the expt structure and save it
%
% Run this when you start a new experiment

loadexpt;

if ~exist('n', 'var')
  n = expt.exptNum + 1;
end

expt.exptNum = n;
fprintf('Setting expt number to %d\n', n);

expt.penetrationNum = 0;
fprintf('Setting penetration number to 0\n');

if isfield(expt, 'probes')
	expt.probes = chooseProbes(expt.probes);
else
	expt.probes = chooseProbes;
end

expt.channelMapping = generateChannelMapping(expt.probes);

printExpt(expt);

saveexpt;

