function newcompensationfilters(filename)
% newcompensationfilters(filename)
%
% Update the compensation filter filename in the expt struct and save it
% [Should this also delete the cached stimuli?]
%
% Run this when you recalibrate

setpath;
loadexpt;

if nargin==0
  filename = input('Input name of file containing calibration filters: ', 's');
end

if ~exist(filename, 'file')
 error(sprintf('File %s does not exist. Doing nothing.', filename));
end

expt.compensationFilterFile = filename;

printExpt(expt);

saveexpt;
