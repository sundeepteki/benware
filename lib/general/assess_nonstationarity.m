function data = assess_nonstationarity(data, min_t, max_t)
  % data = assess_nonstationarity(data, min_t, max_t)
  
  % function for counting spikes in the specified range
  n_spikes = @(x) sum((x >= min_t) & (x <= max_t));
  
  % label all the reps
  count = 0;
  for ii=1:L(data)
    for jj=1:L(data(ii).repeats)
      count = count+1;
      data(ii).repeats(jj).count = count;
    end
  end
  
  % collect all the sweeps
  reps = [data.repeats];
  for ii=1:L(reps)
    ts = reps(ii).timestamp;
    ts = datenum(datevec(ts, 'yyyymmdd-HHMMSSFFF'));
    reps(ii).ts = ts;    
    reps(ii).n = n_spikes(reps(ii).t);
  end
  
  % sort by timestamp
  x = [reps.ts];
  y = [reps.n];
  c = [reps.count];
  [x idx] = sort(x);
  y = y(idx);
  c = c(idx);
  
  % smooth to yield correction
  moving_average = smooth(y, L(y) * 0.5, 'loess')';
  nonstationarity_correction = 1 ./ moving_average;
  
  % add the correction back to the original data
  for ii=1:L(data)
    for jj=1:L(data(ii).repeats)
      count = data(ii).repeats(jj).count;
      data(ii).repeats(jj).nonstationarity_correction = nonstationarity_correction(c==count);
    end
  end
  
  