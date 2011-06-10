function msound(Y,fs)
  wavwrite(Y,fs,16,'/tmp/aaa.wav');
  %[a b] = system('mplayer -msglevel all=-1 /tmp/aaa.wav');
  [a b] = system('music123 /tmp/aaa.wav');
  delete /tmp/aaa.wav 
