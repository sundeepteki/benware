function [stim, stimInfo] = make_and_compensate_dadida(sweepNum, grid, expt)

stimInfo.stimGridTitles = grid.stimGridTitles;
stimInfo.stimParameters = grid.randomisedGrid(sweepNum, :);
params = num2cell(stimInfo.stimParameters);

%stimseq(sampleRate,Afreq,Aamp,Bfreq,Bamp,tondur,ncycles,prestim)

fs = grid.sampleRate;
[Afreq, Bfreq, tondur, ncycles, prestim_id, prestim_ncycles, prestim_freq] = params{1:7};

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
    
    stim(chan,:) = make_dadida(fs, Afreq, Aamp, Bfreq, Bamp, tondur, ncycles, prestim);

end

keyboard;
