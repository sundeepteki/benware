function [stim, stimInfo] = make_and_compensate_dadida(sweepNum, grid, expt)

stimInfo.stimGridTitles = grid.stimGridTitles;
stimInfo.stimParameters = grid.randomisedGrid(sweepNum, :);
params = num2cell(stimInfo.stimParameters);

%stimseq(sampleRate,Afreq,Aamp,Bfreq,Bamp,tondur,ncycles,prestim)

fs = grid.sampleRate;

[bf, delta_f, f0_cond, b_offset, prestim_type, prestim_interrupted, b_random, level] = params{1:8};

f0_multipliers = [0:0.25:1] * delta_f;

Afreq = bf * 2.^[f0_multipliers(f0_cond)];
Bfreq = Afreq / 2.^(delta_f);

%Afreq = [bf * 2.^([0:0.25:1]*delta_f(1)) bf * 2.^([0:0.25:1]*delta_f(2))]; 
%freqB = [bf * 2.^(([0:0.25:1]-delta_f(1))*delta_f(1)) bf * 2.^(([0:0.25:1]-delta_f(2))*delta_f(2))];

c = grid.stimulusConstants;

for chan = 1:length(grid.compensationFilters)
    cf = grid.compensationFilters{chan};
    ft = abs(fft(cf));
    ft = ft(1:length(ft)/2);
    f = linspace(0, fs/2, length(ft));

    Aamp = interp1(f, ft, Afreq);
    Bamp = interp1(f, ft, Bfreq);

    if prestim_freq>0
        prestim_amp = interp1(f, ft, prestim_freq);
    end

    if prestim_id==0
        prestim = {};
    elseif prestim_id==1
        if prestim_freq==0
            prestim_freq = Afreq;
            prestim_amp = Aamp;
        end
        prestim = {'A', prestim_ncycles, prestim_freq, prestim_amp}; 
    elseif prestim_id==2
        if prestim_freq==0
            prestim_freq = Bfreq;
            prestim_amp = Bamp;
        end
        prestim = {'B', prestim_ncycles, prestim_freq, prestim_amp}; 
    end
    
    stim(chan,:) = make_dadida(Afreq, Aamp, c.gapA, Bfreq, Bamp, c.gapB, b_offset, ...
        b_random, c.tondur, c.interval, c.n_prestim_cycles, c.n_test_cycles, ...
        prestim, fs, c.randomseed);

% function [prestimvec testvec stimoutput] = dadidagen(Afreq,Alev,Agap,Bfreq,Blev,Bgap,Bstart, ...
%    Brand,tondur,intdur,nprecycles,ntestcycles,prestim,sampleRate)


end

keyboard;
