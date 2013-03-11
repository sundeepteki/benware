function cleanup(tdt)

fprintf('Cleaning up...');
fclose('all');
diary off;
fprintf('done\n')
%if ~isempty(tdt)
%  resetDevices(tdt);
%end
%closeOpenFiles;
