function closeOpenFiles

fprintf('== Closing open files...');
fclose('all');
diary off;
fprintf('done\n');
