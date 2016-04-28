function answer = demandnumberwithdefault(query,allowable_answers,default)
  % str = demandnumberwithdefault(query,allowable_answers,default)
  
  answer = [];
  while isempty(answer)
    n = input(sprintf('%s [%d] ', query, default));
    if isempty(n)
      answer = default;
    elseif ismember(n, allowable_answers)
      answer = n;
    end
  end