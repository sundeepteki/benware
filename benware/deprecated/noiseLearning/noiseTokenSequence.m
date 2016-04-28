function svect=noiseTokenSequence(isi,sequence, fs, noises)
%
%  makes a sound vector (svect) from noise tokens ready to play given an inter-stimulus
%  interval (isi) in ms and a sequence. 
%  The noise tokens are drawn from global vairable noiseTokens.noise{ii}
%  according to indeces (ii) given in sequence

Nsounds=length(sequence);
% start off with a period of silence
sampsPerInterval=isi/1000*fs;
svect=zeros(1,ceil(sampsPerInterval*(Nsounds+1)));
% now populate
for ii=1:Nsounds,
    noiseStart=ceil((ii-1)*sampsPerInterval)+1;
    noiseEnd=noiseStart+length(noises{sequence(ii)})-1;
    svect(noiseStart:noiseEnd)=noises{sequence(ii)};
end;
