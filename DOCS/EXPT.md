## Running an experiment

### Getting started

Download Benware from http://github.com/beniamino38/benware

For physiology, download calibration code from
http://github.com/beniamino38/newcalib For spike sorting, jump to "Spike
sorting", below


### Benware initial setup

In Matlab:
```
>> cd benware
>> copyuser('ben', '<yourname>')
>> loadexpt
>> expt
```

The 'expt' variable contains essential parameters that you'll need to adjust
to match your hardware setup:
```
expt.userName -- should be the same as you specified with setuser)
expt.stimulusDirectory -- a dir that will be scanned for stimuli
expt.nStimChannels -- number of output audio/voltage channels
expt.stimDeviceInfo -- adjust to match your TDT stimulus device
expt.dataDeviceInfo -- adjust to match your TDT recording device expt.dataRoot
expt.dataRoot -- where you want data to be saved
```

Once you've adjusted these parameters, save using:
```
>> saveexpt
```

### Stimuli

See [STIMULI.md](./STIMULI.md)



### Calibration

See newcalib/README

Once you have some compensation filters, let's say they're in a directory
called 'E:\newcalib\2014.01.01.headphones'. Then, in Matlab:

```
>> cd benware
>> newcompensationfilters('E:\newcalib\2014.01.01.headphones')
```

= Experiment and probe setup

Every time you start a new experiment:
```
$ cd benware
$ newexpt
```

By default, 1 will be added to the experiment number. This number will be used
to make a directory to save data into. You can alternatively provide an
experiment number, e.g. 
```
>> newexpt(10)
```

Every time you start a new penetration:  cd newprobe

Fill in your probe details; the IDs are optional. This will be used to
correctly set the electrode channel mapping so that the Benware display
matches the physical arrangement of the probes.


To run an experiment:
```
>> cd benware
>> benware
```

Choose from the list of stimuli. Press k in the Benware window to see a list
of keys that you can press to produce different kinds of display (waveforms,
rasters, PSTH, LFP).
