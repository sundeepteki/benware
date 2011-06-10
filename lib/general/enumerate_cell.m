function ce = enumerate_cell(c,nums)
  % ce = enumerate_cell(c)
  % ce = enumerate_cell(c,nums)
  
  if nargin==1
    nums = 1:L(c);
  end
  
  c = c(:);
  nums = nums(:);
  
  ce = [n2s(nums) c];