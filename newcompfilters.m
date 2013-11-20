function newcompfilters(dirname)
% newcompfilters(dirname)
%
% Update the compensation filters in the expt struct and save it
% 
% Also delete the cached stimuli??
%
% Run this when you recalibrate

setpath;
loadexpt;

if nargin==0
  dirname = input('Input name of directory containing calibration filters: ', 's');
end

if ~exist(dirname, 'dir')
 error(sprintf('Directory %s does not exist. Doing nothing.', dirname));
end

expt.compensationFilterDir = dirname;
expt.compensationFilterFilename = 'compensationFilters.%dk.mat';

printExpt(expt);

saveexpt;

