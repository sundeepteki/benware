function result = reach2d(parent,daughter,varargin)
  result = reach(parent, daughter, varargin{:});
    % REACH
    %   reach(parent,daughter)
    % where
    %   - parent is a struct
    %   - daughter is a string
    %
    % allows you to retrieve [parent(ii).daughter] when daughter is a
    % series of substructures.
    %
    % eg consider the structure
    %   animals.dog(1:10).woof.volume
    % matlab allows [animals.dog.woof], to give the 10 woofs, but not
    % [animals.dog.woof.volume].
    %
    % instead, type
    %   reach(animals.dog,'woof.volume')
    
