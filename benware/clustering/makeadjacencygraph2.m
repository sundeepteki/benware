function finalNShanks = makeadjacencygraph2(probeShanks, probeType, filename)
%
% function finalNShanks = makeadjacencygraph2(probeShanks, probeType, filename)
%
% probeShanks: cell array where each cell is
% {n_shanks x n_sites}; e.g. {[4 8], [1 8]}
% for a 4x8 and a 1x8
% the probes must be in the same order as you recorded in
% 
% probeType: cell array where each cell is 'l' for linear or 'b' for buzsaki
% e.g. {'l', 'l'}
% 
% filename: filename to save under

if ~iscell(probeShanks)
  probeArrangment = {probeShanks};
end

if ~iscell(probeType)
  probeType = {probeType};
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

nProbes = length(probeShanks);
probes =  {};

firstSite = 0;
shankNum = 0;
for probeIdx = 1:nProbes
  thisProbe = probeShanks{probeIdx};
  thisProbeType = probeType{probeIdx};
  
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
    elseif lower(thisProbeType(1))=='l' % linear
      for siteIdx = 1:nSites
        if siteIdx<nSites
          fprintf(fid, '(%d, %d), ', firstSite+siteIdx-1, firstSite+siteIdx);
        end
      end
    elseif lower(thisProbeType(1))=='b' % buzsaki
      for siteIdx = 1:nSites
        if siteIdx<nSites
          fprintf(fid, '(%d, %d), ', ...
		  firstSite+siteIdx-1, firstSite+siteIdx);

        end
        if siteIdx<nSites-1
          fprintf(fid, '(%d, %d), ', ...
		  firstSite+siteIdx-1, firstSite+siteIdx+1);
        end
      end
    end
    
    fprintf(fid, '],\n');
    
    %% geometry
    %            0: (0, 0),
    fprintf(fid, '        ''geometry'': { \n', nSites);

    if lower(thisProbeType(1))=='l' % linear
      for siteIdx = 0:nSites-1
        fprintf(fid, '            %d: (%d, %d), \n', firstSite+siteIdx, 0, -siteIdx);
      end
    elseif lower(thisProbeType(1))=='b' % buzsaki
      for siteIdx = 0:nSites-2
        fprintf(fid, '            %d: (%d, %d), \n', firstSite+siteIdx, 2*mod(siteIdx,2), -2*siteIdx);
      end
      fprintf(fid, '            %d: (%d, %d), \n', firstSite+nSites-1, 1, -2*(nSites-1));
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
