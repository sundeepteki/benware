function str = demandinput(query,allowable_answers,default,caseInsensitive)
  % str = demandinput(query,allowable_answers)

  if ~exist('caseInsensitive','var')
      caseInsensitive = false;
  end
  
  if caseInsensitive
      allowable_answers = lower(allowable_answers);
  end
  
  str = input(query,'s');
  if ismember(lower(str),allowable_answers)
    return;
  elseif isempty(str) && ~isempty(default)
    % if the user pressed return and there is a default answer, use that
    fprintf([default '\n']);
    str = default;
    return;
  else
    str = demandinput(query,allowable_answers);
  end
  
end