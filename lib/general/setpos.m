function setpos(obj,varargin)

  if nargin==2
    pos = varargin{1};
    set(obj,'position',pos);
    
  elseif nargin>2
    if isequal(varargin{1},'offset')
      pos = getpos(obj) + varargin{2};
      set(obj,'position',pos);
    else
      error('input:error','not sure what to do with this');
    end
    
  else
    error('input:error','not sure what to do with this');
  end
    
end