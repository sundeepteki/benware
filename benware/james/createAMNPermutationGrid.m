function stimGrid = createAMNPermutationGrid(rates1, rates2, contrasts2)
% creates a grid whose rows are all combinations of the inputs, without repetition.

% rates1 = [1:4];
% rates2 = [1:4];
% contrasts2 = [25 50 75 100];

nCols = 3;%%%%%%%length(var)
conts = length(contrasts2);
half_reps = (((length(rates1)^2)/2)-(length(rates1)/2));
conds = conts+(half_reps*(conts-1))+(half_reps*conts);
stimGrid = zeros(conds, nCols)

idx = 1;

% create singe AMNs idx
for i = 1:length(rates1)
    stimGrid(i, 1) = rates1(i);
    stimGrid(i, 2) = 0;
    stimGrid(i, 3) = 0;
    idx = idx+1;
end

for ii=1:length(rates1);
    for jj=1:length(rates2);
        for kk=1:conts;
            if (contrasts2(kk)==100 & jj<=ii);
                continue;
            end
            if jj==ii;
                continue;
            end
            stimGrid(idx, 1) = (floor(rates1(ii)));
            stimGrid(idx, 2) = (floor(rates2(jj)));
            stimGrid(idx, 3) = contrasts2(kk);
            idx = idx+1;
        end
    end
end


  
