function info = neuronexusProbeInfo

% probe site layouts from:
% http://www.neuronexustech.com/support/probe-site-maps
% Should be in SHANK ORDER, i.e. down the first shank, then down the second, etc.
probes = struct();
probes(1).name = 'A1x16';
probes(1).order = [9 8 10 7 13 4 12 5 15 2 16 1 14 3 11 6]; % top to bottom

probes(2).name = 'A4x4';
probes(2).order = [1 3 2 6 7 4 8 5 13 10 12 9 14 16 11 15]; % top to bottom

probes(end+1).name = 'A1x32 (rev 3)';
probes(end).order = [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 ...
				  9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]; % top to bottom

probes(end+1).name = 'A2x16';
twoBySixteen = [9 8 10 7 11 6 12 5 13 4 14 3 15 2 16 1; ...
					25 24 26 23 27 22 28 21 29 20 30 19 31 18 32 17];
					% first shank then second shank
order = transpose(twoBySixteen);
probes(end).order = order(:)';

probes(end+1).name = 'A4x8';
fourByEight = [5 4 6 3 7 2 8 1; 13 12 14 11 15 10 16 9; ...
    			21 20 22 19 23 18 24 17; 29 28 30 27 31 26 32 25];
		 		% top to bottom then left to right
order = transpose(fourByEight);
probes(end).order = order(:)';

probes(end+1).name = 'A4x16';
fourBySixteen = [9 8 10 7 11 6 12 5 13 4 14 3 15 2 16 1; ...
				25 24 26 23 27 22 28 21 29 20 30 19 31 18 32 17; ...
				41 40 42 39 43 38 44 37 45 36 46 35 47 34 48 33; ...
				57 56 58 55 59 54 60 53 61 52 62 51 63 50 64 49];
order = transpose(fourBySixteen);
probes(end).order = order(:)';

% NeuroNexus connector pin maps from:
% http://www.neuronexustech.com/support/probe-site-maps
connectors = struct;
connectors(1).name = 'A16';
connectors(1).pins = [8 7 6 5 4 3 2 1 9 10 11 12 13 14 15 16];
						% probe pointing down, pins facing away
						% left column top to bottom then right

connectors(end+1).name = 'A32 (rev 3)';
connectors(end).pins = [32 0 0 11; 30 0 0 9; 31 0 0 7; 28 0 0 5; 29 26 1 3; ...
						27 24 4 2; 25 20 13 6; 22 19 14 8; 23 18 15 10; 21 17 16 12];
						% looking at pins, with probe pointing down.
						% reference is on the right

connectors(end+1).name = 'A32 (rev 2)';
connectors(end).pins = [32 0 0 1; 31 0 0 2; 30 0 0 3; 29 0 0 4; 28 27 6 5; ...
						26 25 8 7; 24 20 13 9; 23 19 14 10; 22 18 15 11; 21 17 16 12];
% this is made up -- it gives you the right rearrangement to use when you use
% a rev 2 headstage with a rev 3 probe, but it's probably not right in general.

connectors(end+1).name = 'Z32';
connectors(end).pins = [9 7 5 3 30 28 26 24; 13 14 15 16 17 18 19 20; ...
						21 22 23 25 8 10 11 12; 27 29 31 32 1 2 4 6];
%connectors(end).pins = [1:8; 9:16; 17:24; 25:32];
						% probe pointing down,
						% notch (square) at top left (left to right, top then bottom);
						% then notch at top right (left to right, top then bottom)

connectors(end+1).name = 'A64';
connectors(end).pins = [41 0 0 24; 38 0 0 27; 43 0 0 22; 37 0 0 28; 36 39 26 29; ...
						45 40 25 20; 47 42 23 18; 49 44 21 16; 51 46 19 14; 53 48 17 12; ...
						55 0 0 10; 50 0 0 15; 57 0 0 8; 52 0 0 13; 59 54 11 6; ...
						61 60 5 4; 56 33 32 9; 63 62 3 2; 58 35 30 7; 64 34 31 1];
						% looking at pins, with probe pointing down.
						% reference is on the right

% TDT connector pin maps from System 3 Manual
connectors(end+1).name = 'ZCA-NN32';
connectors(end).pins = [10 0 0 8; 12 0 0 6; 14 0 0 4; 16 0 0 2; 11 9 7 5; 15 13 3 1; ...
						28 26 24 22; 32 30 20 18; 27 25 23 21; 31 29 19 17];
						% probe pointing down, reference on the right

connectors(end+1).name = 'ZC32';
connectors(end).pins = [1 3 5 7 9 11 13 15; 2 4 6 8 10 12 14 16; ...
						31 29 27 25 23 21 19 17; 32 30 28 26 24 22 20 18];
						% probe pointing down,
						% notch (square) at left (left to right, top then bottom);
						% then notch at top right (left to right, top then bottom) 

connectors(end+1).name = 'ZCA-NN64';
connectors(end).pins = [18 0 0 16; 20 0 0 14; 22 0 0 12; 24 0 0 10; 28 26 8 6; ...
						32 30 4 2; 19 17 15 13; 23 21 11 9; 27 25 7 5; 31 29 3 1; ...
						50 0 0 48; 52 0 0 46; 54 0 0 44; 56 0 0 42; 60 58 40 38; ...
						64 62 36 34; 51 49 47 45; 55 53 43 41; 59 57 39 37; 63 61 35 33];
						% probe pointing down, reference on the right

% headstages
headstages = struct;
headstages(1).name = 'RA16AC';
headstages(1).inputconnector = 'A16';
headstages(1).outputconnector = 'A16';

headstages(end+1).name = 'ZCA-NN32';
headstages(end).inputconnector = 'A32 (rev 3)';
headstages(end).outputconnector = 'ZCA-NN32';

headstages(end+1).name = 'ZC32 (ZIF-clip)';
headstages(end).inputconnector = 'Z32';
headstages(end).outputconnector = 'ZC32';

headstages(end+1).name = 'ZCA-NN64';
headstages(end).inputconnector = 'A64';
headstages(end).outputconnector = 'ZCA-NN64';

headstages(end+1).name = 'NN32AC (number less than #2000)';
headstages(end).inputconnector = 'A32 (rev 3)';
headstages(end).outputconnector = 'A32 (rev 2)';

headstages(end+1).name = 'NN32AC (#2000 onward)';
headstages(end).inputconnector = 'A32 (rev 3)';
headstages(end).outputconnector = 'A32 (rev 3)';

info.probes = probes;
info.connectors = connectors;
info.headstages = headstages;
