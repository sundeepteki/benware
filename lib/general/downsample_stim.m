function stim_ds = downsample_stim(stim,block_size_ms,sample_rate)
  % DOWNSAMPLE_STIM
  %   stim_ds = downsample_stim(stim,block_size_ms,sample_rate)
  % 
  % Downsamples the stimulus (across all its channels), by INTEGRATING over
  % time. Note that this means that the stimulus must be POSITIVE
  % SEMIDEFINTITE
  %
  % Note that:
  %   - block_size is assumed to be in milliseconds
  %   - sample_rate, if not supplied, is assumed to be 48828 Hz.
  %
  % ----------------------------
  % AUDITORY OBJECTS v2.1.1.2
  % ----------------------------

  
DEFAULT_SAMPLE_RATE = 48828;
  

%% parse inputs
% ================

  % check that stim is positive semidefinite
  if any(stim(:)<0)
    warning('input:error','stimulus should not be negative');
  end
  
  % default sample rate
  if nargin==2
    sample_rate = DEFAULT_SAMPLE_RATE;
  end
  
  % check that stim is correctly oriented
  n.channels = size(stim,1);
  n.maxdt = size(stim,2);
  if n.channels > n.maxdt
    stim = downsample_stim(stim',block_size_ms,sample_rate)';
  end
  
  
%% subdivisions (ie "blocks")

  block.ms = block_size_ms;
  block.dt = block.ms/1000 * sample_rate;
  block.n = floor( n.maxdt / block.dt );
  
  stim_ds = zeros(n.channels,block.n);
  
  for ii=1:block.n
    block.boundary = round( (ii-1)*block.dt + [1 block.dt] );
    ti = block.boundary(1);
    tf = block.boundary(2);
    stim_ds(:,ii) = mean( stim(:,ti:tf) , 2);
  end

end