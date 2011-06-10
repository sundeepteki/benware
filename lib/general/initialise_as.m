function varargout = initialise_as(value)
  % varargout = initialise_as(value)
  
  for ii=1:nargout, 
    varargout{ii} = value;
  end