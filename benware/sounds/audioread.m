function [snd, fs] = audioread(filename)
%% For backward compatibility:
% If audioread exists, use it.
% Otherwise use wavread.

p = path;
path(pathdef);
if ~isempty(which('audioread'))
  [snd, fs] = audioread(filename);
else
  [snd, fs] = wavread(filename);
end
path(p);
