function [s tokeep] = pad_signal_for_filtering(s,n_samples)
  % PAD_SIGNAL_FOR_FILTERING
  %   s = pad_signal_for_filtering(s,n_samples)

    n_samples = min(n_samples, L(s)-1);
  
  % pad on the left and right
    pad.left  = 2*s(1)   - flipud( s( 2:n_samples) );
    pad.right = 2*s(end) - flipud( s( end + ((-n_samples+1):-1)) ) ;
    s = [pad.left; s; pad.right];
    
  % try find endmost zero crossings
    %zc1 = pick(find(((s(:)>0) & (circshift(s(:),-1)<0)) | ((s(:)<0) & (circshift(s(:),-1)>0))),'1');
    %zc2 = pick(find(((s(:)>0) & (circshift(s(:),-1)<0)) | ((s(:)<0) & (circshift(s(:),-1)>0))),'end-1');
    
%     if (L(s)-(zc2-zc1+1))/L(s) > 1e-2
%       warning('pad:signal','more than 1 percent removed due to zero crossings');      
%       keyboard;
%     end
    
  % zeroify
    %s(1:(zc1-1)) = 0;
    %s((zc2+1):end) = 0;
    %s = s .* tukeywin( L(s), 0.05*(L(pad.left)+L(pad.right))/L(s) );
    
  % tokeep
    tokeep = false(size(s));
    tokeep( (L(pad.left)+1) : (L(s)-L(pad.right)) ) = true;    
  
end
    
