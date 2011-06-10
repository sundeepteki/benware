function freqs = standard_freqs
    freqs = 2 .^( log2(0.5e3) : 1/12 : log2(24e3) );
end