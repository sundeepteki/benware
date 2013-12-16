function y = escapepath(x)
% replace '\' with '\\'
% so you can print the string with fprintf

y = regexprep(x, '\', '\\\');
