function sizes = Sincell(c,n)
  % SINCELL
  %   Sincell(c)
  %
  % returns a list of all the sizes of the elements of a cell.
  
  if ~iscell(c)
    ME = MException('input:error','input argument is not a cell');
    throw(ME);
  end
  
  if (size(c,1)==1 | size(c,2)==1 )
    sizes = zeros(size(c));
    for ii=1:L(c)
      sizes(ii) = size(c{ii},n);
    end
    
  elseif L(size(c))==2
    sizes = zeros(size(c));
    for ii=1:size(c,1)
      for jj=1:size(c,2)
        sizes(ii,jj) = size(c{ii,jj},n);
      end
    end
    
  else
    ME = MException('input:error','as yet, only supports 1d or 2d cells - update code');
    throw(ME);
  end
  
end
    