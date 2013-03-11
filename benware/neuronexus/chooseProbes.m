function probes = chooseProbes(oldprobes)

if ~exist('oldprobes', 'var')
	oldprobes = [];
end

probeInfo = neuronexusProbeInfo;

%% gather input
fprintf('\n= How many probes?\n');
num_probes = demandnumberwithdefault('Type the number:', 1:10, max(length(oldprobes), 1));

if ~isempty(oldprobes)
	defaultlayout = oldprobes(1).layout;
	defaultheadstage = oldprobes(1).headstage;
else
	defaultlayout = nan;
	defaultheadstage = nan;
end

for pp = 1:num_probes
	thisprobe = struct();

	% get probe type
	fprintf('\n= Probe %d: Which layout?\n', pp);
	def = 1;
	star = '';
	for ii = 1:length(probeInfo.probes)
		if strcmp(probeInfo.probes(ii).name,defaultlayout)
			star = ' *default*';
			def = ii;
		else
			star = '';
		end
		fprintf(' %d. %s%s\n', ii, probeInfo.probes(ii).name, star);
	end
	layoutnum = demandnumberwithdefault(sprintf('Type 1-%d:', length(probeInfo.probes)), 1:length(probeInfo.probes), def);
	%layoutnum = input(sprintf('Type 1-%d: ', length(probeInfo.probes)));
	if isempty(layoutnum) && ~isempty(defaultlayout)
		thisprobe.layout = defaultlayout;
	else
		thisprobe.layout = probeInfo.probes(layoutnum).name;
	end
	defaultlayout = thisprobe.layout;

	% get headstage type
	fprintf('\n= Probe %d: Which headstage?\n', pp);
	def = 1;
	star = '';
	for ii = 1:length(probeInfo.headstages)
		if strcmp(probeInfo.headstages(ii).name,defaultheadstage)
			star = ' *default*';
			def = ii;
		else
			star = '';
		end
		fprintf(' %d. %s%s\n', ii, probeInfo.headstages(ii).name, star);
	end
	headstagenum = demandnumberwithdefault(sprintf('Type 1-%d:', length(probeInfo.headstages)), 1:length(probeInfo.headstages), def);
	if isempty(headstagenum) && ~isempty(defaultheadstage)
		thisprobe.headstage = defaultheadstage;
	else
		thisprobe.headstage = probeInfo.headstages(headstagenum).name;
	end
	defaultheadstage = thisprobe.headstage;

	default = '';
	if length(oldprobes)>=pp
		default = oldprobes(pp).probeid;
	end
	in = input(sprintf('\nProbe ID [%s]: ', default), 's');
	if isempty(in)
		thisprobe.probeid = default;
	else
		thisprobe.probeid = in;
	end

	default = '';
	if length(oldprobes)>=pp
		default = oldprobes(pp).headstageid;
	end
	in = input(sprintf('Headstage ID [%s]: ', default), 's');
	if isempty(in)
		thisprobe.headstageid = default;
	else
		thisprobe.headstageid = in;
	end

	probes{pp} = thisprobe;
end
probes = [probes{:}];
