function integerxticks(a)
  if nargin==0, a = gca; end
  yts = get(a,'xtick');
  yts = yts(rem(yts,1)==0);
  set(a,'xtick',yts)