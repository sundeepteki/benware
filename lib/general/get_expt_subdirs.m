function sources = get_expt_subdirs(n)
  switch n
    case 10
      sources = get_expt10_subdirs;
    case 11
      sources = get_expt11_subdirs;
    otherwise
      error('input:error','unknown n');
  end
