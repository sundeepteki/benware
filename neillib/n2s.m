function str = n2s(num, nchars)

  if L(num)==1
    if nargin == 1
      str = num2str(num);
    else
      str = num2str(num, ['%0' num2str(nchars) 'd']);
    end
    
  else
    if size(num)>2
      error('input:error','n2s currently only defined for 0/1/2D nums; edit to fix');
    end
    
    if nargin == 1
      str = cell(size(num));
      for ii=1:size(num,1)
        for jj=1:size(num,2)
          str{ii,jj} = n2s(num(ii,jj));
        end
      end
    else
      str = cell(size(num));
      for ii=1:size(num,1)
        for jj=1:size(num,2)
          str{ii,jj} = n2s(num(ii,jj),nchars);
        end
      end
    end
    
  end
end