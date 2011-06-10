function h = histc_weighted(x,edges,weights)

  ngps = L(edges)-1;
  h = nan(ngps,1);
  
  for ii=1:ngps
    xi = edges(ii);
    xf = edges(ii+1);
    tokeep = (x >= xi) & (x < xf);
    if ii==ngps
      tokeep = tokeep | (x==xf);
    end
    h(ii) = sum(weights(tokeep));
  end
  