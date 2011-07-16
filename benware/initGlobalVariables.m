function initGlobalVariables

global state;

% gain of scope trace and other UI variables
if ~exist('state','var')
  state = struct;
end
state.plot.enabled = true;
state.plot.onlyActiveChannel = false;
state.plot.filtered = true;
state.plot.type = 'w';
state.plot.typeShouldChange = false;
if ~isfield(state, 'dataGainRaw')
  state.dataGainRaw = 500;
end
if ~isfield(state, 'dataGainFiltered')
  state.dataGainFiltered = 1000;
end
if ~isfield(state, 'audioMonitor') || ~isfield(state.audioMonitor, 'channel')
  state.audioMonitor.channel = 1;
end
state.audioMonitor.changed = true;
state.shouldPause = false;
state.paused = false;
state.userQuit = false;
state.noData.alreadyWarned = false;
state.noData.warnUser = false;
