function clickOnSubplot(src, eventInfo, chan)

global state

state.audioMonitor.changed = true;
state.audioMonitor.channel = chan;
