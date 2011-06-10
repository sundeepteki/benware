function y = apply(f, varargin)
  if isa(f, 'function_handle')
    y = f(varargin{:});
  else
    error('input:error','f is not a function');
  end