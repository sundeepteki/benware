% save expt variable to appropriate user file
setpath;

l = load('user.mat');
user = l.user;

exptfilename = fix_slashes(['users/expt.' user.name '.mat']);
fprintf(['Saving as ' escapepath(exptfilename) '\n']);
save(exptfilename, 'expt');
