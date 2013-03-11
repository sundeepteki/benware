function printProbes(probes)


fprintf_subtitle('Probes');

for ii = 1:length(probes)
	fprintf('Probe %d\n', ii);
	fprintf('  - probe layout: %s\n', probes(ii).layout);
	fprintf('  - headstage type: %s\n', probes(ii).headstage);
	fprintf('  - probe ID: %s \n', num2str(probes(ii).probeid));
	fprintf('  - headstage ID: %s \n', num2str(probes(ii).headstageid));
	fprintf('\n');
end
