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
    gainDelta = 0.1;
    if ~isempty(eventInfo.Modifier)
      gainDelta = gainDelta * (length(eventInfo.Modifier)+1);
    end
    if state.plot.type=='w'
      if state.plot.filtered
        state.dataGainFiltered = state.dataGainFiltered*(gainDelta+1);
      else
        state.dataGainRaw = state.dataGainRaw*(gainDelta+1);
      end
    elseif state.plot.type=='l'
      state.dataGainLFP = state.dataGainLFP*(gainDelta+1);
    end
  case 'downarrow'
    gainDelta = 0.1;
    if ~isempty(eventInfo.Modifier)
      gainDelta = gainDelta * (length(eventInfo.Modifier)+1);
    end
    
    if state.plot.type=='w'
      if state.plot.filtered
        state.dataGainFiltered = state.dataGainFiltered/(gainDelta+1);
      else
        state.dataGainRaw = state.dataGainRaw/(gainDelta+1);
      end
    elseif state.plot.type=='l'
      state.dataGainLFP = state.dataGainLFP/(gainDelta+1);
    end
  case 'space'
    if state.paused
      state.shouldPause = false;
    else
      state.shouldPause = true;
    end
  case {'delete', 'backspace'}
    state.onlineData = onlineDataInit('reset', [], [], []);
    state.plot.typeShouldChange = true;
end

switch eventInfo.Character
  case 'k'
    % check whether cheat sheet is already open
    if ishandle(102)
      close(102);
    else
      cheatSheet;
    end
  case 'o'
    if state.plot.enabled
      state.plot.shouldDisable = true;
    else
      state.plot.typeShouldChange = true;
    end
    state.plot.enabled = ~state.plot.enabled;
  case {'w', 'r', 'p', 'l', 's'}
    state.plot.enabled = true;
    state.plot.type = eventInfo.Character;
    state.plot.typeShouldChange = true;
  case cellstr(char(49:57)')' % numbers 1-9
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
  case {'>', '.'}
    state.spikeThreshold = state.spikeThreshold*1.1;
    state.spikeThreshold
  case {'<', ','}
    state.spikeThreshold = state.spikeThreshold/1.1;
    state.spikeThreshold
  case {'?', '/'}
    state.spikeThreshold = -state.spikeThreshold;
    state.spikeThreshold

end
