function keyPress(src, eventInfo)
% keyPress(src, eventInfo)
% 
% GUI callback. This function is associated with the main window, and 
% is called when a key is pressed. This function alters the global 'state'
% variable, and these changes are picked up by various parts of the program
% that need to know about them.

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
  case 'a'
    if ~state.plot.enabled
      state.plot.onlyActiveChannel = true;
    else
      state.plot.onlyActiveChannel = ~state.plot.onlyActiveChannel;
    end
    state.plot.enabled = true;
  case 'r'
    state.plot.raster = ~state.plot.raster;
  case 'f'
    state.plot.filtered = ~state.plot.filtered;
  case 'l'
    state.plot.lfp = ~state.plot.lfp;
end
