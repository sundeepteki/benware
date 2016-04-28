function cleanup(hardware)

fprintf('Cleaning up...');
fclose('all');
diary off;
fprintf('done\n')
try
  hardware.stimDevice.reset;
  hardware.dataDevice.reset;
end
%closeOpenFiles;
