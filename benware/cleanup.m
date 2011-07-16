function cleanup(tdt)

fprintf('\n');
if ~isempty(tdt)
  resetDevices(tdt);
end
closeOpenFiles;
