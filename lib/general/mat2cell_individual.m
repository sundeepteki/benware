function c = mat2cell_individual(m)
  % c = mat2cell_individual(m)
  %
  % creates a cell with singleton elements
  
  c = mat2cell(m, ones(1,size(m,1)), ones(1,size(m,2)));