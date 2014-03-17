function newcompensationfilters(dirname)
% newcompensationfilters(dirname)
%
% Update the compensation filter filename in the expt struct and save it
% [Should this also delete the cached stimuli?]
%
% Run this when you recalibrate

setpath;
loadexpt;

if nargin==0
  dirname = input('Input name of directory containing calibration filters: ', 's');
end

filename = [dirname filesep 'compensation_filters.mat'];

if ~exist(filename, 'file')
 error(sprintf('File %s does not exist. Doing nothing.', filename));
end

expt.compensationFilterFile = filename;

printExpt(expt);

saveexpt;
