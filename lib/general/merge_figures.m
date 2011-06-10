function merge_figures(varargin)
  % merge_figures(fig1, fig2, ...)
  
  nfigs = nargin;
  figs = fliplr([varargin{:}]);
  
  % check that they are all valid figs
  badfigs = setdiff(figs, get(0,'children'));
  if ~isempty(badfigs)
    str = 'bad figures: ';
    for ii=1:L(badfigs)
      str = [str n2s(badfigs(ii)) ', '];
    end
    str = str(1:(end-2));
    error('input:error',str);
  end
  
  fn = max(get(0,'children')) + 1;
  figure(fn);
  
  % size
  w = mean(arrayfun(@(x) pick((get(x,'position')),3), figs));
  h = sum(arrayfun(@(x) tail(get(x,'position')), figs));
  
  set_fig_size(w,h,fn);
  
  % reorganise  
  for ff=1:L(figs)
    c = get(figs(ff),'children');
    for ii=1:L(c)
      cc = c(ii);
      pos.old = get(cc,'position');
      pos.new = [...
        pos.old(1) ...
        pos.old(2)/nfigs + (ff-1)/nfigs ...
        pos.old(3) ...
        pos.old(4)/nfigs];
      set(cc,'parent',fn,'position',pos.new);
    end    
    
    try
      close(figs(ff));
    catch
    end
  end
 
    