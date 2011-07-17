function zBus = zBusInit(zBus, stimDevice, dataDevice)

global fakeHardware

if fakeHardware

  if isempty(zBus) || ~deviceIsFake(zBus)
    zBus = fakeZBus([], []);
  else
    fprintf('  * Fake ZBus already connected, doing nothing\n');
  end

else

  if isempty(zBus) || deviceIsFake(zBus)
    zBus=actxcontrol('ZBUS.x',[1 1 1 1]);
    if zBus.ConnectZBUS('GB') == 0
      errorBeep(['Cannot connect to zBUS on GB']);
    end
  else
    fprintf('  * ZBus already connected, doing nothing\n');
  end

end
