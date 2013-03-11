function mapping = generatechannelmapping(probestruct)
% generatechannelmapping

info = neuronexusProbeInfo;
probes = info.probes;
connectors = info.connectors;
headstages = info.headstages;

% test against known mappings
testvalues(1).probe = 'A1x16';
testvalues(end).headstage = 'RA16AC';
testvalues(end).num_probes = 2;
testvalues(end).mapping = [9 8 10 7 13 4 12 5 15 2 16 1 14 3 11 6 25 ...
							24 26 23 29 20 28 21 31 18 32 17 30 19 27 22];

testvalues(end+1).probe = 'A1x32 (rev 3)';
testvalues(end).headstage = 'NN32AC (#2000 onward)';
testvalues(end).num_probes = 1;
testvalues(end).mapping = [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 ...
							 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1];

testvalues(end+1).probe = 'A1x32 (rev 3)';
testvalues(end).headstage = 'NN32AC (number less than #2000)';
testvalues(end).num_probes = 1;
testvalues(end).mapping = [17 16 18 15 19 14 20 13 21 12 23 1 22 11 25 2 24 ...
							10 27 3 26 9 29 4 28 8 31 5 30 7 32 6];

testvalues(end+1).probe = 'A4x8';
testvalues(end).headstage = 'ZC32 (ZIF-clip)';
testvalues(end).num_probes = 1;
testvalues(end).mapping = [5 20 18 7 3 22 23 24 2 17 4 19 6 21 8 1 31 16 29 ...
							14 27 12 15 10 30 11 9 32 28 13 26 25];

fprintf('Running tests');
for ii = 1:length(testvalues)
	fprintf('.');
	probe = probes(find(strcmp({probes(:).name}, testvalues(ii).probe)));
	headstage = headstages(find(strcmp({headstages(:).name}, testvalues(ii).headstage)));
	num_probes = testvalues(ii).num_probes;
	inputconnector = connectors(find(strcmp({connectors(:).name}, headstage.inputconnector)));
	outputconnector = connectors(find(strcmp({connectors(:).name}, headstage.outputconnector)));
	mapping = getchannelmapping(probe, headstage, inputconnector, outputconnector, num_probes);

	%[mapping'==testvalues(ii).mapping' mapping' testvalues(ii).mapping']

	assert(length(mapping)==length(testvalues(ii).mapping));
	assert(all(mapping==testvalues(ii).mapping));
end
fprintf('done\n');
%% check code against known values

mapping = [];
for ii = 1:length(probestruct)
	probe = probes(find(strcmp({probes(:).name}, probestruct(ii).layout)));
	headstage = headstages(find(strcmp({headstages(:).name}, probestruct(ii).headstage)));
	inputconnector = connectors(find(strcmp({connectors(:).name}, headstage.inputconnector)));
	outputconnector = connectors(find(strcmp({connectors(:).name}, headstage.outputconnector)));
	mapping = [mapping getchannelmapping(probe, headstage, inputconnector, outputconnector, 1)+length(mapping)];
end

fprintf('\n= The mapping is:\n');
disp(mapping);


function mapping = getchannelmapping(probe, headstage, inputconnector, outputconnector, num_probes)

if max(probe.order)>length(probe.order) || min(probe.order)<0 || ...
		length(unique(probe.order))~=length(probe.order)
	fprintf('Error: Probe site list is wrong (e.g. not a permutation of 1:32)\n');
	return;
end

pinnums = inputconnector.pins(inputconnector.pins~=0);

if max(pinnums)~=length(probe.order)
	fprintf('Error: Headstage channel count (%d) does not match probe (%d)\n', ...
		max(pinnums), length(probe.order));
	return;
end

if max(pinnums)>length(pinnums) || min(pinnums)<0 || ...
		length(unique(pinnums))~=length(pinnums)
	fprintf('Error: Input connector pin list is wrong (e.g. not a permutation of 0:32 or 1:32)\n');
	return;
end

pinnums = outputconnector.pins(outputconnector.pins~=0);
if max(pinnums)>length(pinnums) || min(pinnums)<0 || ...
		length(unique(pinnums))~=length(pinnums)
	fprintf('Error: Output connector pin list is wrong (e.g. not a permutation of 0:32 or 1:32)\n');
	return;
end

% work out the mapping
mapping = nan(size(probe.order));
for sitenum = 1:length(probe.order)
	f = find(inputconnector.pins==probe.order(sitenum));
	mapping(sitenum) = outputconnector.pins(f);
end

fullmapping = [];
for ii = 1:num_probes
	fullmapping = [fullmapping mapping+(ii-1)*length(probe.order)];
end
mapping = fullmapping;

