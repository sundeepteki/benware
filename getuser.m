function getuser

% load user file
l = load('user.mat');
fprintf('Current user is: %s\n', l.user.name);

