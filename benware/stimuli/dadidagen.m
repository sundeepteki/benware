function stimoutput = dadidagen(Afreq,Alev,Agap,Bfreq,Blev,Bgap,Bstart,Brand,tondur,intdur,nprecycles,ntestcycles,prestim,sampleRate,randseed,jitter,n)
% Assumptions:
%   1. A and B tones are equal in duration
%   2. Priming tone always A, and adopts Agap property

% get prestim
[Aseq Agapseq Bseq Bgapseq prestimvec] = prestimseq(Afreq,Bfreq,Alev,Blev,Agap,Bgap,tondur,intdur,nprecycles,prestim,sampleRate);

% get teststim: A never random or offset
An = ntestcycles(1);
Bn = ntestcycles(2);

testvec = testseq(Aseq,Agapseq,An,Bseq,Bgap,Bgapseq,Bstart,Bn,Brand,sampleRate,randseed,tondur,jitter,n);

% stimoutput = [];
% if iscell(testvec)
%     for k = 1:length(testvec)
%         temp = [startsilencevec prestimvec testvec{k}];
%         stimoutput(k,1:length(temp)) = temp;    % REMEMBER TO TRUNCATE ZEROS LATER!!!
%     end
% else
%     stimoutput = [prestimvec testvec];
% end

stimoutput = [prestimvec testvec];

% Different conditions:

% unprimed ABA: [prestimvec testvec stimoutput] = dadidagen(1000,.5,100,2000,.5,100,100,0,75,25,3,5,0,48828.125,5);
% primed ABA: [prestimvec testvec stimoutput] = dadidagen(1000,.5,100,2000,.5,100,100,0,75,25,3,5,[1 1000 .5],48828.125,5);
% interrupt ABA: [prestimvec testvec stimoutput] = dadidagen(1000,.5,100,2000,.5,100,100,0,75,25,3,5,[1 500 .3],48828.125,5);
% unprimed synchronous: [prestimvec testvec stimoutput] = dadidagen(1000,.5,100,2000,.5,100,0,0,75,25,3,5,0,48828.125,5);
% unprimed random: [prestimvec testvec stimoutput] = dadidagen(1000,.5,100,2000,.5,100,0,1,75,25,3,5,0,48828.125,5);

% 4 against 3: [prestimvec testvec stimoutput] = dadidagen(1000,.5,100,2000,.5,150,0,0,75,25,3,[10 8],0,48828.125,5);


% CONTROLS:

% primed As only: [prestimvec testvec stimoutput] = dadidagen(1000,.5,100,2000,.5,100,0,0,75,25,3,[10 0],[1 1000 .5],48828.125,5);
% *primed Bs only: [prestimvec testvec stimoutput] = dadidagen(1000,.5,100,2000,.5,100,100,0,75,25,3,[0 10],[1 1000 .5],48828.125,5);
% primed interrupt, A's only: [prestimvec testvec stimoutput] = dadidagen(1000,.5,100,2000,.5,100,100,0,75,25,3,[10 0],[1 500 .5],48828.125,5);
% *primed interrupt, B's only: [prestimvec testvec stimoutput] = dadidagen(1000,.5,100,2000,.5,100,100,0,75,25,3,[0 10],[1 500 .5],48828.125,5);
% unprimed As only: [prestimvec testvec stimoutput] = dadidagen(1000,.5,100,2000,.5,100,100,0,75,25,3,[10 0],0,48828.125,5);
% *unprimed Bs only: [prestimvec testvec stimoutput] = dadidagen(1000,.5,100,2000,.5,100,100,0,75,25,3,[0 10],0,48828.125,5);
% *unprimed B random: [prestimvec testvec stimoutput] = dadidagen(1000,.5,100,2000,.5,100,100,1,75,25,3,[0 10],0,48828.125,5);

