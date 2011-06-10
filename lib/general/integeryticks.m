function integeryticks(a)
  if nargin==0, a = gca; end
  yts = get(a,'ytick');
  yts = yts(rem(yts,1)==0);
  set(a,'ytick',yts)