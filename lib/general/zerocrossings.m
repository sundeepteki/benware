function pos = zerocrossings(x)
  % pos = zerocrossings(x)
  %
  % finds the positions pos where x crosses 0
  
  pos = find(~(diff(sign(x))==0));