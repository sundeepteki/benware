function grid = grid_bubd_hf_73dB()

% load 83dB grid and alter to 73dB
grid = grid_bubd_hf_83dB;

grid.name = 'bubd_hf.73dB';
grid.stimGrid(:,end) = 73;
