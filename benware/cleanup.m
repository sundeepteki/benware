function cleanup(hardware)

fprintf('Cleaning up...');
fclose('all');
diary off;
fprintf('done\n')
%if ~isempty(hardware)
%  resetDevices(hardware);
%end
%closeOpenFiles;
