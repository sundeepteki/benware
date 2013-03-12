function grid = grid_bubd_bb_73dB()

% load 83dB grid and alter to 73dB
grid = grid_bubd_bb_83dB;

grid.name = 'bubd_bb.73dB';
grid.stimGrid(:,end) = 73;
