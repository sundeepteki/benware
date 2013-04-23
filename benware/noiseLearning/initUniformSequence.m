function initUniformSequence(seqLen),
%
% make a uniform sequence of specified length using the random number
% generator of noiseTokens and its random seed
%
global noiseTokens

if isempty(noiseTokens),
    error('noiseTokens not initialized');
end

nTokens=numel(noiseTokens.noise);

RandStream.setDefaultStream(noiseTokens.randomStream);
reset(noiseTokens.randomStream);

x=[];
while numel(x) < seqLen,
    r = randperm(nTokens);
    if ~isempty(x) && r(1)==x(end)
        r = fliplr(r);
    end
   
    x=[x r];
end;

d = diff(x);
assert(all(d~=0));

x=x(1:seqLen);

noiseTokens.uniformSequence=x;

