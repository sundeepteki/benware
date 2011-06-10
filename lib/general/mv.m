function varargout = mv(varargin)
  [SUCCESS,MESSAGE,MESSAGEID] = movefile(varargin{:});
  
  for ii=1:nargout
    switch ii
      case 1
        varargout{ii} = SUCCESS;
      case 2
        varargout{ii} = MESSAGE;
      case 3
        varargout{ii} = MESSAGEID;
      otherwise
        error('input:error','too many outputs requested');
    end
  end
    
    