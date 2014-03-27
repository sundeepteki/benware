function finalNShanks = makeadjacencygraph(probeArrangement, filename)
% probeArrangment: cell array where each cell is
% {n_shanks x n_sites}; e.g. {[4 8], [1 8]}
% for a 4x8 and a 1x8
% the probes must be in the same order as you recorded in
%
% this has become a bit of a mess. shanksAreCloseTogether = true is for
% e.g. the Warp-16, where there is a 2D grid of sites. In this case, we
% define a single shank with the correct adjacency relationships (a grid)

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

if ~exist('shanksAreCloseTogether', 'var')
  shanksAreCloseTogether = false;
end

if length(probeArrangement)>1 && length(shanksAreCloseTogether)==1
  shanksAreCloseTogether = repmat(shanksAreCloseTogether, [1 length(probeArrangement)]);
end

nProbes = length(probeArrangement);
probes =  {};

firstSite = 0;
shankNum = 0;
for probeIdx = 1:nProbes
  thisProbe = probeArrangement{probeIdx};
  theseShanksAreCloseTogether = shanksAreCloseTogether(probeIdx);
  
  nShanks = thisProbe(1);
  nSites = thisProbe(2);
  
  fprintf(fid, ' # Probe %d\n', probeIdx);
  
  if theseShanksAreCloseTogether
    shankNum = shankNum + 1;
    fprintf(fid, ' %d: [', probeIdx);
  end
  
  probes{probeIdx} = {};
  for shankIdx = 1:nShanks
    if theseShanksAreCloseTogether
      fprintf(fid, '\n  ');
    else
      shankNum = shankNum + 1;
      fprintf(fid, ' %d: [', shankNum);
    end
    lastSite = firstSite + nSites-1;

    if nSites==1
      fprintf(fid, '(%d, -1), ', firstSite);
    else
      for siteIdx = 1:nSites
        if siteIdx<nSites
          fprintf(fid, '(%d, %d), ', firstSite+siteIdx-1, firstSite+siteIdx);
        end
        if theseShanksAreCloseTogether && shankIdx<nShanks
          fprintf(fid, '(%d, %d), ', firstSite+siteIdx-1, firstSite+siteIdx+nSites-1);
        end
      end
    end
    firstSite = firstSite + nSites;
    
    if ~theseShanksAreCloseTogether
      fprintf(fid, '],\n');
    end    
    
  end
  if theseShanksAreCloseTogether
    fprintf(fid, '],\n');
  end
end

fprintf(fid, '}\n');
if (fid~=1)
  fclose(fid);
end

finalNShanks = shankNum;
