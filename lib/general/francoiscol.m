function c = francoiscol

%   a = linspace(0,1,32);
%   b = linspace(1,0,32);  
  b = cos((0:31)/32 * pi/2);
  a = fliplr(b);
  
  a = [zeros(1,32) a; zeros(2,64)]';
  b = [zeros(2,64); b zeros(1,32)]';
  c = flipud(a+b);
  