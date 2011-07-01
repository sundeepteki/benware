function zBus = zBusInit(zBus)

if isempty(zBus)
  zBus=actxcontrol('ZBUS.x',[1 1 1 1]);
  if zBus.ConnectZBUS('GB') == 0
    errorBeep(['Cannot connect to zBUS on GB']);
  end
else
  fprintf('  * ZBus already connected, doing nothing\n');
end
