function copyuser(a, b)
% copy user a to user b
setpath;

% copy grids
copyfile(['./grids/grids.' a], ['./grids/grids.' b]);

% copy expt structure
copyfile(['./users/expt.' a '.mat'], ['./users/expt.' b '.mat']);

% update username in expt struct
load(['./users/expt.' b '.mat']);
expt.userName = b;
save(['./users/expt.' b '.mat'], 'expt');
