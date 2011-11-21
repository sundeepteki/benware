function grid = grid_bubd_lf_73dB()

% load 83dB grid and alter to 73dB
grid = grid_bubd_lf_83dB;

grid.name = 'bubd_lf.73dB';
grid.stimGrid(:,end) = 73;
