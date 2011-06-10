function v = get_sve(raster)
  % v = get_sve(raster)
  %
  % rasters is a NxT matrix
  % where N is the number of trials
  % and T is the number of time bins
    
  % initialise structure
    v = struct;
    v.mean = nan(1,L(data));
    v.explainable = nan(1,L(data));

  % number of trials
    N = size(raster,1);
  % number of time bins
    T = size(raster,2);

  % calculate v explainable
    v.mean = var(mean(raster));
    v.explainable = 1/(N-1) * (N * var(mean(raster)) - mean(var(raster,[],2)));
    v.unexplainable = v.mean - v.explainable;

  % how much noise is there
    v.noise_ratio = v.unexplainable / v.explainable;

  % what number you need to multiply the "proportion of variance explained"
  % to get the "proportion of explainable-variance explained"
    v.scale_performance_factor = v.mean / v.explainable;

  % if the data are shit
    if v.explainable < 0
      v.explainable = 0;
      v.unexplainable = v.mean;
      v.noise = Inf;
      v.scale_performance_factor = nan;
    end

end