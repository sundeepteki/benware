function totalsum = nanmultisum(varargin)
  % totalsum = nanmultisum(x1,x2,...)
  
  % check all sizes are the same
  s = size(varargin{1});
  for ii=2:nargin
    if ~isequal(size(varargin{ii}),s)
      error('input:error','not all the same size');
    end
  end
  
  % what are nans in each argument
  arenans = cellfunc(@isnan,varargin);
  
  % what are nans in all arguments
  areallnans = arenans{1};
  for ii=2:nargin
    areallnans = areallnans & arenans{ii};
  end
  
  % turn nans into zeros
  denaned = varargin;
  for ii=1:nargin
    denaned{ii}(arenans{ii}) = 0;
  end
  
  % sum these up
  totalsum = 0*denaned{1};
  for ii=1:nargin
    totalsum = totalsum + denaned{ii};
  end
  
  % what is nan in all is nan in the totalsum
  totalsum(areallnans) = nan;
  
