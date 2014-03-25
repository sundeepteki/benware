function makeadjacencygraph(probeArrangement, filename)
% probeArrangment: cell array where each cell is
% {n_shanks x n_sites}; e.g. {[4 8], [1 8]}
% for a 4x8 and a 1x8
% the probes must be in the same order as you recorded in

if ~iscell(probeArrangement)
  probeArrangment = {probeArrangement};
end

if exist('filename', 'var') && ~isempty(filename)
  fid = fopen(filename, 'w');
  if fid==-1
    error(sprintf('Error opening file %s', filename));
  end
else
  fid = 1;
end

fprintf(fid, 'probes = {\n');

nProbes = length(probeArrangement);
probes =  {};

firstSite = 0;
outputShankNum = 0;

for probeIdx = 1:nProbes
  thisProbe = probeArrangement{probeIdx};
  
  nShanks = thisProbe(1);
  nSites = thisProbe(2);
  
  fprintf(fid, ' # Probe %d\n', probeIdx);
  
  probes{probeIdx} = {};
  for shankIdx = 1:nShanks
    outputShankNum = outputShankNum + 1;
    fprintf(fid, ' %d: [', outputShankNum);
    
    lastSite = firstSite + nSites-1;
    for siteIdx = 1:nSites
      if siteIdx<nSites
        fprintf(fid, '(%d, %d), ', firstSite+siteIdx-1, firstSite+siteIdx);
      end
    end
    firstSite = firstSite + nSites;
    
    fprintf(fid, '],\n');
    
  end
end

fprintf(fid, '}\n');
if (fid~=1)
  fclose(fid);
end
