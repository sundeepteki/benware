function grid = grid_pe_73dB()

% load 83dB grid and alter to 73dB
grid = grid_pe_83dB;

grid.name = 'pe.73dB';
grid.stimGrid(:,end) = 73;
