function h = histc_nolast(x, edges)
  try
    h = histc(x,edges);
    h(end-1) = h(end-1)+h(end);  
    h = h(1:(end-1));
  catch
    h = zeros(1, L(edges)-1);
  end  
end