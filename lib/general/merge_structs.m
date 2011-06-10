function s1 = merge_structs(s1, s2)
  % s = merge_structs(s1, s2)
  
  % size of structure
  n.s1 = L(s1);
  n.s2 = L(s2);
  if n.s1>1 || n.s2>1
    error('input:error','currently have not coded merge_structs for more than singleton structs. fix.');
  end
    
  if isempty(s1) | isempty(fieldnames(s1))
    n.s1 = 0; 
  end

  % fields of s2
  fields = fieldnames(s2);
  n.f = L(fields);
  
  % add to the structure
  for ii=1:n.f
    field = fields{ii};
    s1.(field) = s2.(field);
  end
