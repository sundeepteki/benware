function t = textbf(x,y,str,varargin)
  
  
    str = bfify(str);
    t = text(x,y,str,varargin{:});  
   
end 
  

function s = bfify(s)

  if ischar(s)
    s = ['{\bf' s '}'];
  elseif iscell(s)
    for ii=1:L(s)
      s{ii} = bfify(s{ii});
    end
  else
    error('input:error','s is not a string');
  end

end
