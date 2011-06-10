function s = append_to_struct(s, element)
  % s = append_to_struct(s, element)
  %
  % appends the element to the end of s, by copying each field
  % independently
  
  % size of structure
  n.s = L(s);
  if isempty(s) | isempty(fieldnames(s))
    n.s = 0; 
  end

  % fields of the element
  fields = fieldnames(element);
  n.f = L(fields);
  
  % add to the structure
  for ii=1:n.f
    field = fields{ii};
    s(n.s+1).(field) = element.(field);
  end
