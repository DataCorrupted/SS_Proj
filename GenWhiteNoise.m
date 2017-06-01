duration = 10;
fs = 44100;
y0 = zeros(1, duration * fs);

y0 = y0';
y1 = awgn(y0,10);
plot(y1(1:500));

devWriter = audioDeviceWriter;
%fileWriter = dsp.AudioFileWriter('noise.wav','FileFormat','WAV');
tic;
audiowrite('WhiteNoise.wav', y1, fs);

release(devWriter);     % close the audio output device
%release(fileWriter);    % close the output file