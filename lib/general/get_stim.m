function data = get_stim(n,stim_format)
  % data = get_stim(n,stim_format)
  %
  % retrieves stimulus data, where stim_format is:
  %   'gt':   gammatones data
  %   'lgt':  log(gammatones) [thresholded] data
  %   'sg':   spectrogram data
  %   'an':   auditory nerve data
  %   'am':   amplitude modulation data

  if n>320
    error('input:error','n must be less than 320');
  elseif ~(n==round(n))
    error('input:error','n must be an integer');
  end
  
  switch stim_format
    case 'gt'
      files = dir(['sounds/gt/gt.' n2s(n,3) '*.mat']);
      filename = files(1).name;
      data = load(['sounds/gt/' filename]);
      data = data.gt;
    case 'lgt'
      files = dir(['sounds/lgt/lgt.' n2s(n,3) '*.mat']);
      filename = files(1).name;
      data = load(['sounds/lgt/' filename]);
      data = data.lgt;      
    case 'gthi'
      files = dir(['sounds/gthi/gt.' n2s(n,3) '*.mat']);
      filename = files(1).name;
      data = load(['sounds/gthi/' filename]);
      data = data.gthi;
    case 'lgthi'
      files = dir(['sounds/lgthi/lgt.' n2s(n,3) '*.mat']);
      filename = files(1).name;
      data = load(['sounds/lgthi/' filename]);
      data = data.lgthi;      
    case 'sg'
      files = dir(['sounds/sg/sg.' n2s(n,3) '*.mat']);
      filename = files(1).name;
      data = load(['sounds/sg/' filename]);
      data = data.sg;
    case 'an'
      files = dir(['sounds/an/an.' n2s(n,3) '*.mat']);
      filename = files(1).name;
      data = load(['sounds/an/' filename]);
      data = data.an;
    case 'am'
      files = dir(['sounds/am/am.' n2s(n,3) '*.mat']);
      filename = files(1).name;
      data = load(['sounds/am/' filename]);
      data = data.am;
      
      
      
    otherwise
      error('input:error','invalid stim_format');
  end
end
      