function clickOnSubplot(src, eventInfo, chan)
% clickOnSubplot(src, eventInfo, chan)
% 
% GUI callback. This function is associated with every subplot of the main
% display, and is called when the mouse is clicked. Currently, clicking
% sets the channel that the audio monitor listens to. This is achieved
% by setting a flag in the global 'state', which is later picked up by
% runSweep. runSweep then tells the TDT to change channel.

global state

state.audioMonitor.changed = true;
state.audioMonitor.channel = chan;
