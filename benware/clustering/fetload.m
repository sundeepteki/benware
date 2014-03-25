function data = fetload(fetfile)
% load klustakwik .fet file

data = dlmread(fetfile, ' ');
n_features = data(1);
assert(size(data, 2)== n_features);
data = data(2:end,:);
