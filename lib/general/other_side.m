function side2 = other_side(side1)
  switch side1
    case 'L'
      side2 = 'R';
    case 'R'
      side2 = 'L';
  end