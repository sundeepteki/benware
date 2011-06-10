function x = capat(x,varargin)
  % y = capat(x,xmax)
  % y = capat(x,xmin,xmax)
  % y = capat(x,xmin,xmax,nan)
  
  asnan = false;
  if nargin==2
    xmin = nan;
    xmax = varargin{1};
    
  elseif nargin==3
    xmin = varargin{1};
    xmax = varargin{2};
    
  elseif nargin==4
    xmin = varargin{1};
    xmax = varargin{2};
    if ischar(varargin{3})
      if strcmp(varargin{3},'isnan') | strcmp(varargin{3},'asnan') | strcmp(varargin{3},'nan')
        asnan = true;
      end
    elseif isnan(varargin{3})
      asnan = true;
    end        
    
  else
    error('input:error','incorrect # args');
  end
  
  if asnan
    x(x<xmin) = nan;
    x(x>xmax) = nan;
  else
    x(x<xmin) = xmin;
    x(x>xmax) = xmax;
  end
end