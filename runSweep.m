function data = runSweep(sweepLen,stim,dataGain)
%% run a sweep

global zBus stimDevice dataDevice;
global fs_in fs_out;

%
fprintf('Uploading stimulus to TDT...');
uploadWholeStimulus(stim);
fprintf(['done after ' num2str(toc) ' sec.\n']);

% tell data device how long the sweep will be
resetDataDevice(sweepLen*1000);

% check for stale data in TDT buffer
if any(countAllData~=0)
    error('Stale data in data buffer');
end

% make buffer for data
data = {};
for chan = 1:32
   data{chan} = zeros(1,ceil(sweepLen*fs_in));
end
index = zeros(1,32);

% trigger stimulus presentation and data collection
triggerZBus;

fprintf('Sweep triggered.\n');
now = toc;

% download data as fast as possible while trial is running
figure(2);
while any(index+1~=ceil(sweepLen*fs_in))
    for chan = 1:32
        newdata = downloadData(chan,index(chan));
        data{chan}(index(chan)+1:index(chan)+length(newdata)) = newdata;
        index(chan) = index(chan)+length(newdata)-1;
        subplot(8,4,chan);
        plot((1:100:length(data{chan}))/fs_in,data{chan}(1:100:end));
    end
    drawnow;
end

fprintf(['Sweep done after ' num2str(toc) ' sec.\n']);

% check all channels have the same amount of data
dataLen = length(data{1});
for ii = 2:32
    if length(data{ii})~=dataLen
        error('Different amounts of data from different channels');
    end
end

fprintf(['Got ' num2str(dataLen) ' samples from 32 channels (' num2str(dataLen/fs_in) ' sec).\n']);

checkdata = true;
if checkdata
    fprintf('Checking data...');
    testdata = downloadAllData;
    for chan = 1:32
       d = max(abs(data{chan}-testdata{chan})); 
       if d>0
            error('Data mismatch!');
       end
    end
    fprintf(['done after ' num2str(toc) ' sec.\n']);
end
