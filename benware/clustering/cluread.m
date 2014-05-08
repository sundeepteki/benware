function clusterID = cluread(clu)

data = dlmread(clu, '\n');
nClusters = data(1);
clusterID = data(2:end);
%fprintf('%d, %d', nClusters, max(clusterID));
%assert(max(clusterID)==nClusters-1);

