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
    if state.plot.filtered
        state.dataGainFiltered = state.dataGainFiltered*1.25;
    else
        state.dataGainRaw = state.dataGainRaw*1.25;
    end
  case 'downarrow'
    if state.plot.filtered
        state.dataGainFiltered = state.dataGainFiltered/1.25;
    else
        state.dataGainRaw = state.dataGainRaw/1.25;
    end
  case 'space'
    if state.paused
      state.shouldPause = false;
    else
      state.shouldPause = true;
    end
end

switch eventInfo.Character
  case 'o'
    if state.plot.enabled
      state.plot.shouldDisable = true;
    else
      state.plot.typeShouldChange = true;
    end
    state.plot.enabled = ~state.plot.enabled;
  case {'w', 'r', 'p'}
    state.plot.enabled = true;
    state.plot.type = eventInfo.Character;
    state.plot.typeShouldChange = true;
  case 'a'
    if ~state.plot.enabled
      state.plot.onlyActiveChannel = true;
    else
      state.plot.onlyActiveChannel = ~state.plot.onlyActiveChannel;
    end
    state.plot.activeChannelShouldChange = true;
    state.plot.enabled = true;
  case 'f'
    state.plot.filtered = ~state.plot.filtered;
  case 'q'
    state.userQuit = true;
end
