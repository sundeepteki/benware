function z = nanmsem(x)
    % MSEM(x) returns [mean(x) sem(x)]
    
    if min(size(x))>1 | size(size(x))>2
      error('input:error','nanmsem can only deal with 1D arrays for now');
    end
    
    z = [nanmean(x) nanstd(x)/sqrt(L(x(~isnan(x))))];
    
end