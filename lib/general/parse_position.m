function [xi xf w yi yf h] = parse_position(pos)
  % [xi xf w yi yf h] = parse_position(pos)
  xi = pos(1);
  yi = pos(2);
  w = pos(3);
  h = pos(4);
  xf = xi+w;
  yf = yi+h;
  