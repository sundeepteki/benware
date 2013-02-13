function dadida = testseq(Aseq,Agapseq,An,Bseq,Bgap,Bgapseq,Bstart,Bn,Brand,sampleRate,randseed,tondur,jitter,n)
% JITTER version!
% jitter = [Ajitter Auniposs Asig Bjitter Bunipoiss Bsig];

Aramp = Aseq;
Bramp = Bseq;
Astartseq = [];

% first check jitter params
if jitter(1) == 0   % A no jitter
    Acycle = repmat([Aramp Agapseq],1,An);
else
    if jitter(2) == 1 % uniform random distribution
        rand('seed',randseed(n,1));   % randseed(1) is A, randseed(2) is B
        Arandgaps = Agap + 2*(rand(1,An)-0.5)*jitter(3);
        Acycle = [];
        for k = 1:An
            Agapseq = ramps(sampleRate,Arandgaps(k),0);
            Acycle(end+1:end+length(Agapseq)+length(Aramp)) = [Agapseq Aramp];
        end
    else    % poisson random distribution
        rand('seed',randseed(n,1));
        Arandgaps = Agap + exprnd(jitter(3),1,An)-jitter(3);
        for k = 1:An
            Agapseq = ramps(sampleRate,Arandgaps(k),0);
            Acycle(end+1:end+length(Agapseq)+length(Aramp)) = [Agapseq Aramp];
        end
    end
end

% % % if length(Afreq)>1   % randomise A freq
% % %     randAfreq = cell(nreps,1);
% % %     for rr = 1:nreps
% % %         rand('seed',randseed(rr))
% % %         Brandgaps = exprnd(Bgap,[1 Bn]);
% % %         Brandseq = [];
% % %         for k = 1:length(Brandgaps)
% % %             Bgapseq = ramps(sampleRate,Brandgaps(k),0);
% % %             Bcurrent = [Bgapseq Bramp];
% % %             Brandseq(end+1:end+length(Bcurrent)) = Bcurrent;
% % %         end
% % %         Bstream = [Bstartseq Brandseq];
% % %         Astream(end+1:length(Bstream)) = 0;
% % %         Bstream(end+1:length(Astream)) = 0;
% % %         randB{rr,1} = Astream+Bstream;
% % % %         if length(Bstream)<Bn*(length(Bseq)+(Bgap/1000*sampleRate))
% % % %             Bstream(end+1:round(Bn*(length(Bseq)+(Bgap/1000*sampleRate)))) = 0;
% % % %         end
% % %     end
% % %     testvec = randB;
    
    
% % now for B jitter
% if jitter(4) == 0   % B no jitter
%     Bcycle = repmat([Bramp Bgapseq],1,An);
% else
%     if jitter(5) == 1 % uniform random distribution
%         rand('seed',randseed(2));
%         Brandgaps = Bgap+2*(rand(1,Bn)-0.5)*jitter(6);
%         Bcycle = [];
%         for k = 1:Bn
%             Bgapseq = ramps(sampleRate,Brandgaps(k),0);
%             Bcycle(end+1:end+length(Bgapseq)+length(Bramp)) = [Bramp Bgapseq];
%         end
%     else    % poisson random distribution
%         rand('seed',randseed(2));
%         Brandgaps = Bgap + exprnd(jitter(6),1,Bn)-jitter(6);
%         for k = 1:Bn
%             Bgapseq = ramps(sampleRate,Brandgaps(k),0);
%             Bcycle(end+1:end+length(Bgapseq)+length(Bramp)) = [Bramp Bgapseq];
%         end
%     end
% end

% now for B jitter
if jitter(4) == 0   % B no jitter
    Bcycle = repmat([Bramp Bgapseq],1,An);
    if Bstart>0
        Bstartseq = ramps(sampleRate,Bstart,0);
    else
        Bstartseq = [];
    end
    Bstream = [Bstartseq Bcycle];
else
    if jitter(5) == 1 % uniform random distribution
        rand('seed',randseed(n,2));
        Brandsig = 2*(rand(1,Bn)-0.5)*jitter(6);
        Bcycle = [];
        for k = 1:Bn
            if k == 1
                Bprevtend = 0;
                Bstartt = Bstart+(k-1)*(Bgap+tondur);   % where B SHOULD start
                Bstarttjitter = Bstartt+Brandsig(k);    % t where B starts
                Bgapt = Bstarttjitter-Bprevtend;
                Bgapseq = ramps(sampleRate,Bgapt,0);
                Bprevtend = Bstarttjitter+tondur;
            else
                Bstartt = Bstart+(k-1)*(Bgap+tondur);   % where B SHOULD start
                Bstarttjitter = Bstartt+Brandsig(k);    % t where B starts
                Bgapt = Bstarttjitter-Bprevtend;
                Bgapseq = ramps(sampleRate,Bgapt,0);
                Bprevtend = Bstarttjitter+tondur;
            end
            Bcycle(end+1:end+length(Bgapseq)+length(Bramp)) = [Bgapseq Bramp];
        end
    else    % poisson random distribution
        rand('seed',randseed(n,2));
        Brandgaps = Bgap + exprnd(jitter(6),1,Bn)-jitter(6);
        for k = 1:Bn
            Bgapseq = ramps(sampleRate,Brandgaps(k),0);
            Bcycle(end+1:end+length(Bgapseq)+length(Bramp)) = [Bgapseq Bramp];
        end
    end
    Bstream = Bcycle;
end

% Acycle = repmat([Aramp Agapseq],1,An);

Astream = [Astartseq Acycle];








% if Brand == 0
%     Bcycle = repmat([Bramp Bgapseq],1,Bn-1);
%     if Bn == 0
%         Bstream = [Bstartseq Bcycle];
%     else
%         if ~isnan(tau)
%             if tau ~= 0
%                 Btauseq = ramps(sampleRate,tau,0);
%             else
%                 Btauseq = [];
%             end
%         elseif ~isnan(tdotoverT)
%             if tdotoverT ~= 0
%                 taucalc = tdotoverT*tondur;     % T = tone duration
%                 Btauseq = ramps(sampleRate,taucalc,0);
%             else
%                 Btauseq = [];
%             end
%         else
%             keyboard
%         end
%         Bstream = [Bstartseq Bcycle Btauseq Bramp];
%     end
% elseif Brand == 1   % random B gap has mean of Bgap
%     rand('seed',randseed)
%     Brandgaps = exprnd(Bgap,[1 Bn]);
%     Brandseq = [];
%     for k = 1:length(Brandgaps)
%         Bgapseq = ramps(sampleRate,Brandgaps(k),0);
%         Bcurrent = [Bgapseq Bramp];
%         Brandseq(end+1:end+length(Bcurrent)) = Bcurrent;
%     end
%     Bstream = [Bstartseq Brandseq];
%     if length(Bstream)<Bn*(length(Bseq)+(Bgap/1000*sampleRate))
%         Bstream(end+1:round(Bn*(length(Bseq)+(Bgap/1000*sampleRate)))) = 0;
%     end
% end

% add zeros to make sure Astream and Bstream same length
Astream(end+1:length(Bstream)) = 0;
Bstream(end+1:length(Astream)) = 0;

dadida = Astream+Bstream;


function stim = ramps(sampleRate,duration,freq)
% code from Ben Willmore

% time
t = 0:1/sampleRate:duration/1000;

% sinusoid
uncalib = sin(2*pi*freq*t);

% ramp up and down
ramplen_samples = round(5/1000*sampleRate);
ramp = (1-cos(pi*(1:ramplen_samples)/ramplen_samples))/2;
env = [ramp ones(1,length(uncalib)-2*length(ramp)) fliplr(ramp)];

if duration < 10    % assumes anything < 10ms is NOT a sound
    stim = zeros(size(uncalib));
else
    stim = uncalib.*env;
end

