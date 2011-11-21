function grid = grid_po_73dB()

% load 83dB grid and alter to 73dB
grid = grid_po_83dB;

grid.name = 'po.73dB';
grid.stimGrid(:,end) = 73;
