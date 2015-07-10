function finalNShanks = makeadjacencygraph(probeArrangement, filename)
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

fprintf(fid, 'channel_groups = {\n');

nProbes = length(probeArrangement);
probes =  {};

firstSite = 0;
shankNum = 0;
for probeIdx = 1:nProbes
  thisProbe = probeArrangement{probeIdx};
  
  nShanks = thisProbe(1);
  nSites = thisProbe(2);
  
  fprintf(fid, '    # Probe %d\n', probeIdx);
  
  probes{probeIdx} = {};
  for shankIdx = 1:nShanks
    shankNum = shankNum + 1;
    fprintf(fid, '    %d: {\n', shankNum-1);

    %% num channels
    lastSite = firstSite + nSites-1;
    fprintf(fid, '        ''channels'': range(%d, %d),\n', firstSite, lastSite+1);

    %% adjacency graph
    fprintf(fid, '        ''graph'': [ ', nSites);

    if nSites==1
      fprintf(fid, '(%d, %d), ', firstSite, firstSite);
    else
      for siteIdx = 1:nSites
        if siteIdx<nSites
          fprintf(fid, '(%d, %d), ', firstSite+siteIdx-1, firstSite+siteIdx);
        end
      end
    end
    
    fprintf(fid, '],\n');
    
    %% geometry
    %            0: (0, 0),
    fprintf(fid, '        ''geometry'': { \n', nSites);

    for siteIdx = 0:nSites-1
      fprintf(fid, '            %d: (%d, %d), \n', firstSite+siteIdx, 0, siteIdx);
    end
    fprintf(fid, '        },\n    },\n');

    firstSite = firstSite + nSites;

  end
end

fprintf(fid, '}\n');
if (fid~=1)
  fclose(fid);
end

finalNShanks = shankNum;
