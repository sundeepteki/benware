function errorBeep(varargin)
% produce a beep and an error

bbeep;
error(varargin{:});
