function z = msem(x)
    % MSEM(x) returns [mean(x) sem(x)]
    
    z = [mean(x) std(x)/sqrt(L(x))];
    
end