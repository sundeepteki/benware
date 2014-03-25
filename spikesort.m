function spikesort(dir)
  
setpath;

% convert to spikedetekt format
paramsFile = benware2spikedetekt(dir);

fprintf('Now:\n');
fprintf('cd %s\n', [dir filesep 'spikedetekt']);
fprintf(['python ' pwd '/klustakwik/detektspikes.py ' paramsFile '\n']);
fprintf('cd %s\n', [dir filesep 'spikedetekt_1']);
fprintf([pwd '/klustakwik/MaskedKlustaKwik ' paramsFile(1:end-7) ' <shanknum>\n']);

% % detekt spikes
% dir1 = [dir '/spikedetekt'];
% dir2 = [dir filesep 'spikedetekt_2'];
% if exist(dir2, 'dir')
%   fprintf('%s already exists, skipping spike detektion\n');
% else
%   cmdstr = ['python ' pwd '/klustakwik/detektspikes.py ' paramsFile];
%   cmdstr
%   cd(dir1);
%   unix(cmdstr);
% end
% 
% % klustakwik

