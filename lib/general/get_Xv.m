function Xv = get_Xv(X, w)

%% default parameters
% =====================

  n.tt = 10;
  n.ff = 34;
  n.ii = L(X);
  tbtk = 1:n.ii;
      
%% get X
% =========  

  % add offset to grid
    grid_offset = n.tt-1;
    G = [zeros(n.ff,grid_offset) X]';
  
  % construct XP (x proper)
    XP = zeros(n.ii, n.ff+1, n.tt+1);
    
  % fill in time bins
    for ii=1:n.tt
      lag = ii-1;
      XP(:, 1:n.ff, ii) = G( tbtk - lag + grid_offset, : );
    end

  % add constant term
    XP(:,n.ff+1,n.tt+1) = 1;
    
  % get X.v
    Xv = ( t3_v(XP,w.t)*w.f )';  
    

