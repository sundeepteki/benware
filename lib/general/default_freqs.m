function freqs = default_freqs
  
  freqs = 2 .^( log2(0.5e3) : 1/6 : log2(24e3) );