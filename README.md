## Benware

Benware is a simple matlab-based neurophysiology program.


# Getting started

Download Benware from http://github.com/beniamino38/benware

For physiology, download calibration code from
http://github.com/beniamino38/newcalib For spike sorting, jump to "Spike
sorting", below


# Benware initial setup

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

# Stimuli

Stimuli can be provided in many different ways. The simplest is to add a
directory inside the directory pointed to by expt.stimulusDirectory containing
wav files:

1. Make wav or 32-bit floating point files (extension .f32) containing your
stimuli. Take note of the following important constraints:

A: Your wav files must have a TDT supported sample rate (eg. 48828 or 97656
Hz).

B: All wav files in a given directory must have the same sample rate.

C: The values in your wav files will be interpreted as pressures in Pascals.
This means that, if you make a 1kHz tone in Matlab, with an RMS of 1, it will
be played at 1 Pascal RMS, I.E. 94dB.

D: You should be careful about the calibrated range of the equipment.
Currently, this means that at 48828Hz, your stimuli should contain only
frequencies between 200 and 22kHz, and at 97656Hz, your stimuli should contain
only frequencies between 200 and 32kHz. If your stimulus contains frequencies
outside this range, they will be attenuated by the equipment, and so the
overall level of your sounds will be lower than you expect.

E: The maximum length of your wav files should be 40 seconds.  F: If
you want the same stimulus in both ears, use mono wav files. If you want
different stimuli in the two ears, use stereo wav files.

2. Put your sound files in a directory. The name of this directory is what
benware will call your stimulus

3. Optionally, add a file ‘parameters.txt’ inside your directory. This can
contain many different parameters, but the ones you are likely to need are:
```
reps = 10     # (the number of times your stimulus is repeated; defaults to 20)
sampleRate = 48828     # (only necessary for .f32 files)
```


## Calibration

-- see newcalib/README

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
>> newexpt(10).
```

Every time you start a new penetration:  cd newprobe

Fill in your probe details; the IDs are optional. This will be used to
correctly set the electrode channel mapping so that the Benware display
matches the physical arrangement of the probes.


= To run an experiment:
```
>> cd benware
>> benware
```

Choose from the list of stimuli. Press k in the Benware window to see a list
of keys that you can press to produce different kinds of display (waveforms,
rasters, PSTH, LFP).


## Spike sorting

# Installation

Linux:

1. Install prerequisites using apt-get: 
```
sudo apt-get install h5utils libhdf5-dev 
sudo apt-get install libblas-dev liblapack-dev gfortran
sudo apt-get install python-sip-dev python-qt4-dev 
sudo apt-get install python-qt4 qt4-dev-tools libxext-dev
```

2. Copy the following files from lin-wjhs002.dpag.ox.ac.uk:
```
scp -r ben@lin-wjhs002.dpag.ox.ac.uk:/usr/local/klustasuite /usr/local/
scp -r ben@lin-wjhs002.dpag.ox.ac.uk:/usr/local/bin/klusta /usr/local/bin/
scp -r ben@lin-wjhs002.dpag.ox.ac.uk:/usr/local/bin/klustaviewa /usr/local/bin/
```

3. Download Benware from http://github.com/beniamino38/benware

Mac:

1. Install prerequisites using brew:
```
brew install hdf5 <others?>
```

2. Copy the following files from Ben's laptop: 
```
scp -r ben@mc-dpag0036.dpag.ox.ac.uk:/usr/local/klustasuite /usr/local/ 
scp -r ben@mc-dpag0036.dpag.ox.ac.uk:/usr/local/bin/klusta /usr/local/bin/ 
scp -r ben@mc-dpag0036.dpag.ox.ac.uk:/usr/local/bin/klustaviewa /usr/local/bin/
```

3. Download Benware from http://github.com/beniamino38/benware


Windows (NOT RECOMMENDED)

1. Download Benware from http://github.com/beniamino38/benware

2. Install pythonxy (MinGW package needed)

3. Install generic python packages using pythonxy: You *must* have pytables
version 3.0.0, numpy version 1.8.1 and pandas version 0.12

4. Make sure that distutils uses MinGW (howto see for example
https://github.com/cython/cython/wiki/InstallingOnWindows) Create a file named
distutils.cfg (if you already don't have it) in your PythonXYLibdistutils and
add to it the following lines:
```
[build]
compiler = mingw32
```

6. Download and install klustakwik (using 'git clone' or .zip link on the
page): https://github.com/klusta-team/klustakwik -- click zip link or
```
git clone https://github.com/klusta-team/klustakwik.git
```

Then:
```
cd klustakwik
make NOOPENMP=1
sudo mv KlustaKwik /usr/local/bin/
[Check it works by typing: cd~; KlustaKwik]
```
7. Download *customised* klustaviewa from:
http://willmore.eu/klustaviewa-0.3.0-bw.zip

 cd klustaviewa-0.3.0-bw
 sudo python setup.py install

[Check it works by typing: 'cd ~; klusta', cd ~; klustaviewa' ]


# Clustering

If your data from expt 64 was saved in /data/expt64, in Matlab:
```
>> cd benware
>> clusterspikes('/data/expt64');
```

This will go through each directory in turn, convert the data to a klusta-
compatible format, find spikes and do automatic clustering. You can redo this
for a single directory with (not in matlab):
```
$ cd /data/expt64/P10-decorr.v2
$ klusta *.kwik
```

Now, you can load the results of clustering back into matlab with:
>> spiketimes = getsortedspikes('/data/expt64', true, true) % NB 3rd argument = true

Setting the 3rd argument to true gets the auto-clustered spikes, not hand-
sorted ones.

# Manual editing of clusters

Now, in terminal, run klustaviewa: on all shanks, e.g.:
```
$ cd /data/expt64/P10-decorr.v2
$ klustaviewa *kwik
```

You can go through the different shanks using the File menu -> change shank

Now, get the spike times into Matlab:
```
>> spiketimes = getsortedspikes('/data/expt64')
```

Not setting the third argument (i.e. letting it default to false) gets the
hand-sorted spikes.

