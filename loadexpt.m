% load expt variable from appropriate user file
setpath;

l = load('user.mat');
user = l.user;

l = load(fix_slashes(['users/expt.' user.name '.mat']));
expt = l.expt;
