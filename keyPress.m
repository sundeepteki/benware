function keyPress(src, eventInfo)

global state;

if isempty(eventInfo.Character)
  return;
end

switch eventInfo.Key
  case 'uparrow'
    state.dataGain = state.dataGain*1.25;
  case 'downarrow'
    state.dataGain = state.dataGain/1.25;
  case 'space'
    if state.paused
      state.shouldPause = false;
    else
      state.shouldPause = true;
    end
end

switch eventInfo.Character
  case 'p'
    state.plot.enabled = ~state.plot.enabled;
  case 'r'
    state.plot.raster = ~state.plot.raster;
  case 'w'
    state.plot.waveform = ~state.plot.waveform;
  case 'f'
    state.plot.filtered = ~state.plot.filtered;
  case 'l'
    state.plot.lfp = ~state.plot.lfp;
end
