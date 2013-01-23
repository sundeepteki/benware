function stimoutput = dadidagen(Afreq,Alev,Agap,Bfreq,Blev,Bgap,Bstart,Brand,tondur,intdur,nprecycles,ntestcycles,prestim,sampleRate,randseed)
% Assumptions:
%   1. A and B tones are equal in duration
%   2. Priming tone always A, and adopts Agap property

% get prestim
[Aseq Agapseq Bseq Bgapseq prestimvec] = prestimseq(Afreq,Bfreq,Alev,Blev,Agap,Bgap,tondur,intdur,nprecycles,prestim,sampleRate);

% get teststim: A never random or offset

if length(ntestcycles) == 1
    An = ntestcycles*2;
    Bn = An;
else
    An = ntestcycles(1);
    Bn = ntestcycles(2);
end

testvec = testseq(Aseq,Agapseq,An,Bseq,Bgap,Bgapseq,Bstart,Bn,Brand,sampleRate,randseed);

stimoutput = [prestimvec testvec];

% Different conditions:

% constants:
% Alev,  Blev, f_s
% c.Agap, c.Bgap, c.tondur, c.interval, c.n_pre_cycles, c.randseed

% Non controls:
% unprimed ABA: Afreq = {:}, Bfreq = {:}, Bstart = 100, Brand = 0, ntestcycles = 5, prestim = 0
% primed ABA: Afreq = {:}, Bfreq = {:}, Bstart = 100, Brand = 0, ntestcycles = 5, prestim = [1 1000 .5] (i.e. [1 freq lev])
% interrupt ABA: Afreq = {:}, Bfreq = {:}, Bstart = 100, Brand = 0, ntestcycles = 5, prestim = [1 500 .3] (i.e. [1 freq lev])
% unprimed sync: Afreq = {:}, Bfreq = {:}, Bstart = 0, Brand = 0, ntestcycles = 5, prestim = 0
% unprimed random: Afreq = {:}, Bfreq = {:}, Bstart = 0, Brand = 1, ntestcycles = 5, prestim = 0

% Controls:
% primed As only: Afreq = BF, Bfreq = BF-0.5 or 1 oct, Bstart = 0, Brand = 0, ntestcycles = [10 0], prestim = [1 1000 .5]
% primed Bs only: Afreq = BF, Bfreq = BF-0.5 or 1 oct, Bstart = 100, Brand = 0, ntestcycles = [0 10], prestim = [1 1000 .5]
% primed interrupt, A's only: Afreq = BF, Bfreq = BF-0.5 or 1 oct, Bstart = 100, Brand = 0, ntestcycles = [10 0], prestim = [1 500 .5]
% primed interrupt, B's only: Afreq = BF, Bfreq = BF-0.5 or 1 oct, Bstart = 100, Brand = 0, ntestcycles = [0 10], prestim = [1 500 .5]
% unprimed As only: Afreq = BF, Bfreq = BF-0.5 or 1 oct, Bstart = 100, Brand = 0, ntestcycles = [10 0], prestim = 0
% unprimed Bs only: Afreq = BF, Bfreq = BF-0.5 or 1 oct, Bstart = 100, Brand = 0, ntestcycles = [0 10], prestim = 0
% unprimed B random: Afreq = BF, Bfreq = BF-0.5 or 1 oct, Bstart = 100, Brand = 1, ntestcycles = [0 10], prestim = 0



% unprimed ABA: [prestimvec testvec stimoutput] = dadidagen(Afreq,Alev,c.Agap,Bfreq,Blev,c.Bgap,100,0,c.tondur,c.interval,c.n_pre_cycles,5,0,f_s,c.randseed);
% primed ABA: [prestimvec testvec stimoutput] = dadidagen(Afreq,Alev,c.Agap,Bfreq,Blev,c.Bgap,100,0,c.tondur,c.interval,c.n_pre_cycles,5,[1 1000 .5],f_s,c.randseed);
% interrupt ABA: [prestimvec testvec stimoutput] = dadidagen(Afreq,Alev,c.Agap,Bfreq,Blev,c.Bgap,100,0,c.tondur,c.interval,c.n_pre_cycles,5,[1 500 .3],f_s,c.randseed);
% unprimed synchronous: [prestimvec testvec stimoutput] = dadidagen(Afreq,Alev,c.Agap,Bfreq,Blev,c.Bgap,0,0,c.tondur,c.interval,c.n_pre_cycles,5,0,f_s,c.randseed);
% unprimed random: [prestimvec testvec stimoutput] = dadidagen(Afreq,Alev,c.Agap,Bfreq,Blev,c.Bgap,0,1,c.tondur,c.interval,c.n_pre_cycles,5,0,f_s,c.randseed);

% CONTROLS:

% primed As only: [prestimvec testvec stimoutput] = dadidagen(Afreq,Alev,c.Agap,Bfreq,Blev,c.Bgap,0,0,c.tondur,c.interval,c.n_pre_cycles,[10 0],[1 1000 .5],f_s,c.randseed);
% primed Bs only: [prestimvec testvec stimoutput] = dadidagen(Afreq,Alev,c.Agap,Bfreq,Blev,c.Bgap,100,0,c.tondur,c.interval,c.n_pre_cycles,[0 10],[1 1000 .5],f_s,c.randseed);
% primed interrupt, A's only: [prestimvec testvec stimoutput] = dadidagen(Afreq,Alev,c.Agap,Bfreq,Blev,c.Bgap,100,0,c.tondur,c.interval,c.n_pre_cycles,[10 0],[1 500 .5],f_s,c.randseed);
% primed interrupt, B's only: [prestimvec testvec stimoutput] = dadidagen(Afreq,Alev,c.Agap,Bfreq,Blev,c.Bgap,100,0,c.tondur,c.interval,c.n_pre_cycles,[0 10],[1 500 .5],f_s,c.randseed);
% unprimed As only: [prestimvec testvec stimoutput] = dadidagen(Afreq,Alev,c.Agap,Bfreq,Blev,c.Bgap,100,0,c.tondur,c.interval,c.n_pre_cycles,[10 0],0,f_s,c.randseed);
% unprimed Bs only: [prestimvec testvec stimoutput] = dadidagen(Afreq,Alev,c.Agap,Bfreq,Blev,c.Bgap,100,0,c.tondur,c.interval,c.n_pre_cycles,[0 10],0,f_s,c.randseed);
% unprimed B random: [prestimvec testvec stimoutput] = dadidagen(Afreq,Alev,c.Agap,Bfreq,Blev,c.Bgap,100,1,c.tondur,c.interval,c.n_pre_cycles,[0 10],0,f_s,c.randseed);

